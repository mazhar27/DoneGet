//
//  ServicesDetailsForm.swift
//  Done
//
//  Created by Mazhar Hussain on 14/07/2022.
//

import UIKit
import Combine
import OpalImagePicker
import Photos
import PhotosUI
import Localize_Swift

class ServicesDetailsForm: BaseViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableVu: UITableView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var proceedButton: UIButton!
    
    //MARK: - Variables
    
    let viewModel =  ServicesDetailFormViewModel()
    private var bindings = Set<AnyCancellable>()
    var formData = [Service_questions]()
    var serviceData : Service?
    var dataArray = [AMPGenericObject]()
    var selectedQuestion = [QuestionAnswerHandeling]()
    var change = false
    var imagesDataArray = [UIImage]()
    let imagePickerCamera = UIImagePickerController()
    
    //MARK: - Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        viewModel.getServicesForm(serviceID: String(SessionModel.shared.subServiceID), categoryID: String(SessionModel.shared.categoryID))
        bindViewModel()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if let indexExist = SessionModel.shared.cartServiceEditIndex{
            viewModel.getServicesForm(serviceID: String(SessionModel.shared.subServiceID), categoryID: String(SessionModel.shared.categoryID))
            titleLbl.text = SessionModel.shared.subServiceName
            subTitleLbl.text = SessionModel.shared.categoryName
            print(indexExist)
        }
        
    }
    deinit {
        print("services details form deinit called")
    }
    
    private func initialSetup(){
        self.proceedButton.setTitle("Proceed".localized(), for: .normal)
        if Localize.currentLanguage() == "ar" {
            self.backButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }else{
            self.backButton.transform = .identity
        }
        titleLbl.text = SessionModel.shared.subServiceName
        subTitleLbl.text = SessionModel.shared.categoryName
        let nib1 = UINib(nibName: "ServiceQuestionTVC", bundle: nil)
        let nib2 = UINib(nibName: "ServicesFormFooterTVC", bundle: nil)
        let nib3 = UINib(nibName: "ServiceFormHeaderTVC", bundle: nil)
        let nib4 = UINib(nibName: "textVuTVC", bundle: nil)
        tableVu.register(nib1, forCellReuseIdentifier: "ServiceQuestionTVC")
        tableVu.register(nib2, forCellReuseIdentifier: "ServicesFormFooterTVC")
        tableVu.register(nib4, forCellReuseIdentifier: "textVuTVC")
        tableVu.register(UINib(nibName: "CustomHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CustomHeaderView")
        tableVu.register(nib3, forCellReuseIdentifier: "ServiceFormHeaderTVC")
        tableVu.separatorStyle = .none
        tableVu.delegate = self
        tableVu.dataSource = self
        
        
    }
    private func bindViewModel() {
        
        viewModel.imagesUploadResult
            .sink{ [weak self] completion in
                switch completion {
                case .failure(let error):
                    // Error can be handled here (e.g. alert)
                    DispatchQueue.main.async {
                        self?.showAlert("Done".localized(), error.localizedDescription)
                    }
                    return
                case .finished:
                    return
                }
            } receiveValue: { [weak self] imagesData in
                let images = imagesData
                print(images)
                SessionModel.shared.imagesArray = imagesData
                self?.moveToNextController()
            }.store(in: &bindings)
        
        viewModel.validationResult
            .sink{ [weak self] completion in
                switch completion {
                case .failure(let error):
                    // Error can be handled here (e.g. alert)
                    DispatchQueue.main.async {
                        self?.showAlert("Done".localized(), error.localizedDescription)
                    }
                    return
                case .finished:
                    return
                }
            } receiveValue: { [weak self] formDetails in
                self?.serviceData = formDetails.service
                if formDetails.service_questions != nil {
                    self?.formData = formDetails.service_questions!
                    self?.mapModels(serviceQuestions: self!.formData)
                    self?.tableVu.reloadData()
                }
            }.store(in: &bindings)
        
        
    }
    private func mapModels(serviceQuestions: [Service_questions]) {
        
        for question in serviceQuestions {
            
            let parentObj = AMPGenericObject()
            parentObj.questionId = question.question_id
            parentObj.name = question.question_title
            //            parentObj.optionId = question.optionID
            //
            parentObj.isExpanded = false
            parentObj.level = 0
            parentObj.type  = 0
            if question.optiontree?.count ?? 0 > 0 {
                parentObj.canBeExpanded = true
                parentObj.optiontree = question.optiontree ?? []
            }
            else {
                parentObj.canBeExpanded = false
            }
            
            dataArray.append(parentObj)
        }
    }
    private func validateAllSelectedOption() -> Bool {
        var result = true
        for row in dataArray{
            if(row.selectedOption == ""){
                result = false
                break
            }
        }
        return result
        
    }
    func moveToNextController(){
        let storyboard = getMainStoryboard()
        guard let providerVC = storyboard.instantiateViewController(ProvidersListVC.self) else {
            return
        }
        providerVC.inputParameter.options = dataArray.compactMap{$0.optionId}
        SessionModel.shared.option_id = dataArray.compactMap{$0.optionId}
        providerVC.inputParameter.category_id = SessionModel.shared.categoryID
        show(providerVC, sender: self)
    }
    
    @IBAction func proceedBtnTpd(_ sender: Any) {
        if !validateAllSelectedOption(){
            //   showToast(message: "Please choose all questions options")
            
            showAlert("Done".localized(), "Answer all questions".localized(), .error)
            return
            
        }else{
            if imagesDataArray.count != 0{
                viewModel.uploadImages(images: imagesDataArray)
            }else{
                moveToNextController()
            }
        }
    }
    //    alert to open image picker
    func addImagePicker(title: String, msg: String, imagePicker: UIImagePickerController) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ [weak self](UIAlertAction)in
            print("Camera button clicked")
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            self?.present(imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Photos", style: .default , handler:{ [weak self] (UIAlertAction)in
            self?.openMultipleImagePicker(limit: (5 - (self?.imagesDataArray.count ?? 0)))
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    @IBAction func backBtnTpd(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}






//MARK: - UITableViewDelegate

extension ServicesDetailsForm: UITableViewDelegate, UITableViewDataSource,UITextViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count + 2
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == dataArray.count || indexPath.row == dataArray.count + 1 {
            return 140
        }else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == dataArray.count {
            return tableViewCellDescriptionQA(tableView, cellForRowAt: indexPath)
            
        }else if indexPath.row == dataArray.count + 1{
            //            return tableViewCellImagesQA(tableView, cellForRowAt: indexPath)
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServicesFormFooterTVC", for: indexPath) as? ServicesFormFooterTVC
            guard let cell = cell else { return UITableViewCell() }
            cell.initialSetup(imagesdata: imagesDataArray)
            cell.uploadImgBtn.addTarget(self, action: #selector(uploadImagesBtnTpd(sender:)), for: .touchUpInside)
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }else{
            
            let  cell = tableView.dequeueReusableCell(withIdentifier: "ServiceQuestionTVC", for: indexPath) as? ServiceQuestionTVC
            guard let cell = cell else { return UITableViewCell() }
            cell.configureCell(item: dataArray[indexPath.row])
            cell.optionTapped = optionTapped
            cell.options = dataArray[indexPath.row].optiontree
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderView") as? CustomHeaderView
        guard let headerVu = headerView else { return UITableViewCell() }
        guard let servicedata = serviceData else{ return headerVu }
        headerVu.configureCell(service: servicedata)
        return headerVu
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    func tableViewCellImagesQA(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServicesFormFooterTVC", for: indexPath) as? ServicesFormFooterTVC
        guard let cell = cell else { return UITableViewCell() }
        cell.initialSetup(imagesdata: imagesDataArray)
        cell.uploadImgBtn.addTarget(self, action: #selector(uploadImagesBtnTpd(sender:)), for: .touchUpInside)
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    func tableViewCellDescriptionQA(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "textVuTVC", for: indexPath) as? textVuTVC
        guard let cell = cell else { return UITableViewCell() }
        cell.textVu.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    @objc func uploadImagesBtnTpd(sender: UIButton){
        
//        openMultipleImagePicker(limit: 5)
        addImagePicker(title: "", msg: "", imagePicker: imagePickerCamera)
    }
    
    func openMultipleImagePicker(limit: Int){
        //        imagePicker.configuration = nil
        let imagePicker = OpalImagePickerController()
        
        
        
        imagePicker.maximumSelectionsAllowed = limit // This is the line that relates to your question
        imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
        //Present Image Picker
        presentOpalImagePickerController(imagePicker, animated: true, select: { [weak self] imagesAssets in
            print("update ui")
            let images = getAssetThumbnail(assets: imagesAssets)
            if self?.imagesDataArray.count != 0{
                self?.imagesDataArray.append(contentsOf: images)
            }else{
                self?.imagesDataArray = images
            }
            self?.tableVu.reloadRows(at: [IndexPath(row: (self?.dataArray.count ?? 0) + 1, section: 0)], with: .none)
            imagePicker.dismiss(animated: true, completion: nil)
            imagePicker.removeFromParent()
        }, cancel: {
            //Cancel action?
            imagePicker.removeFromParent()
            
        })
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please tell us about your problem".localized()
            textView.textColor = UIColor.lightGray
        }else{
            SessionModel.shared.serviceDescription = textView.text!
        }
    }
    
}

//MARK: - UITableViewExpending Logic

extension ServicesDetailsForm{
    func optionTapped(for option: Optiontree, cell: ServiceQuestionTVC) {
        
        if  let indexPath = tableVu.indexPath(for: cell) {
            let prod = dataArray[indexPath.row]
            dataArray[indexPath.row].selectedOption = option.option ?? ""
            dataArray[indexPath.row].optionId = option.id ?? 0
            if prod.canBeExpanded {
                if prod.isExpanded {
                    
                    if !isOptionExists(option: option, question: prod) {
                        print("Option not exists")
                        collapseCellsFromIndexOf(prod, indexPath: indexPath, tableView: tableVu)
                        
                        expandCellsFromIndexOf(prod, option, indexPath: indexPath, tableView: tableVu)
                        addSelectedOptions(option: option, prod: prod)
                        
                        
                    } else {
                        print("Option already exists")
                        collapseCellsFromIndexOf(prod, indexPath: indexPath, tableView: tableVu)
                        
                        for (index, selectedOption) in selectedQuestion.enumerated() {
                            if selectedOption.optionId == option.id && selectedOption.questionId == prod.questionId {
                                
                                selectedQuestion.remove(at: index)
                                
                                
                            }
                        }
                        expandCellsFromIndexOf(prod, option, indexPath: indexPath, tableView: tableVu)
                    }
                    
                }
                else{
                    
                    expandCellsFromIndexOf(prod, option, indexPath: indexPath, tableView: tableVu)
                    addSelectedOptions(option: option, prod: prod)
                }
                
            }
        }
    }
    
    private func isOptionExists(option: Optiontree, question: AMPGenericObject) -> Bool {
        
        for selectedOption in selectedQuestion {
            if selectedOption.optionId == option.id && selectedOption.questionId == question.questionId {
                return true
            }
        }
        
        return false
        
    }
    func collapseCellsFromIndexOf(_ prod:AMPGenericObject,indexPath:IndexPath,tableView:UITableView)->Void{
        
        // Find the number of childrens opened under the parent recursively as there can be expanded children also
        let collapseCol = numberOfCellsToBeCollapsed(prod)
        prod.children.removeAll()
        
        // Find the end index by adding the count to start index+1
        let end = indexPath.row + 1 + collapseCol
        // Find the range from the parent index and the length to be removed.
        let collapseRange =  ((indexPath.row+1) ..< end)
        // Remove all the objects in that range from the main array so that number of rows are maintained properly
        dataArray.removeSubrange(collapseRange)
        prod.isExpanded = false
        // Create index paths for the number of rows to be removed
        var indexPaths = [IndexPath]()
        for i in 0..<collapseRange.count {
            indexPaths.append(IndexPath.init(row: collapseRange.lowerBound+i, section: 0))
        }
        // Animate and delete
        tableView.deleteRows(at: indexPaths, with: .left)
        
    }
    
    func expandCellsFromIndexOf(_ prod:AMPGenericObject, _ option: Optiontree, indexPath:IndexPath,tableView:UITableView)->Void{
        
        // Create dummy children
        fetchChildrenforParent(prod,option)
        
        
        // Expand only if children are available
        if(prod.children.count>0)
        {
            prod.isExpanded = true
            var i = 0;
            // Insert all the child to the main array just after the parent
            for prodData in prod.children {
                dataArray.insert(prodData, at: indexPath.row+i+1)
                i += 1;
            }
            
            // Find the range for insertion
            let expandedRange = NSMakeRange(indexPath.row, i)
            
            var indexPaths = [IndexPath]()
            // Create index paths for the range
            for i in 0..<expandedRange.length {
                indexPaths.append(IndexPath.init(row: expandedRange.location+i+1, section: 0))
            }
            // Insert the rows
            tableView.insertRows(at: indexPaths, with: .none)
        }
        
    }
    func fetchChildrenforParent(_ parentProduct:AMPGenericObject, _ option: Optiontree){
        
        // If canBeExpanded then only we need to create child
        
        if(parentProduct.canBeExpanded){
            // If Children are already added then no need to add again
            if(parentProduct.children.count > 0){
                parentProduct.children.removeAll()
                //return
            }
            
            if let questiontree = option.questiontree {
                if questiontree.count > 0 {
                    for question in questiontree {
                        let qusObj = AMPGenericObject()
                        qusObj.questionId = question.question_id
                        qusObj.name = question.question_title
                        //                        qusObj.optionId = question.optionID
                        qusObj.isExpanded = false
                        qusObj.level = 0
                        qusObj.type  = 0
                        if question.optiontree?.count ?? 0 > 0 {
                            qusObj.canBeExpanded = true
                            qusObj.optiontree = question.optiontree ?? []
                        }
                        else {
                            qusObj.canBeExpanded = false
                        }
                        
                        parentProduct.children.append(qusObj)
                    }
                }
            }
            
        }
    }
    
    
    func numberOfCellsToBeCollapsed(_ prod:AMPGenericObject)->Int{
        
        var total = 0
        
        if(prod.isExpanded)
        {
            // Set the expanded status to no
            
            prod.isExpanded = false
            let child = prod.children
            total = child.count
            
            // traverse through all the children of the parent and get the count.
            
            for prodData in child{
                selectedQuestion.removeAll{$0.questionId == child[0].questionId}
                
                
                total += numberOfCellsToBeCollapsed(prodData)
                
            }
            
        }
        return total
    }
    private func addSelectedOptions(option: Optiontree,prod: AMPGenericObject) {
        if selectedQuestion.count > 0{
            for question in selectedQuestion {
                if (question.questionId == prod.questionId)  {
                    print("Already Exist")
                    break
                } else {
                    let newValue = QuestionAnswerHandeling(optionId: option.id, questionId: prod.questionId)
                    selectedQuestion.append(newValue)
                    break
                }
            }
        }else{
            let newValue = QuestionAnswerHandeling(optionId: option.id, questionId: prod.questionId)
            selectedQuestion.append(newValue)
            
        }
    }
    
}

extension ServicesDetailsForm: ImagesQATableViewCellDelegate {
    func imagesQATableViewCell(tag: Int) {
        imagesDataArray.remove(at: tag)
    }
    func uploadImage() {
        addImagePicker(title: "", msg: "", imagePicker: imagePickerCamera)
    }
    
}
extension ServicesDetailsForm : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imagesDataArray.append(pickedImage)
            tableVu.reloadRows(at: [IndexPath(row: (dataArray.count) + 1, section: 0)], with: .none)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}




