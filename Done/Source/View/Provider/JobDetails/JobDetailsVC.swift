//
//  JobDetailsVC.swift
//  Done
//
//  Created by Mazhar Hussain on 09/09/2022.
//

import UIKit
import Combine
import MapKit
import Localize_Swift

class JobDetailsVC: BaseViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var secondBtn: UIButton!
    @IBOutlet weak var firstBtn: UIButton!
    @IBOutlet weak var buttonsOuterVu: UIView!
    @IBOutlet weak var buttonOuterHeightCons: NSLayoutConstraint!
    @IBOutlet weak var tbvu: UITableView!
    
    //MARK: - Variables
    
    let viewModel = JobDetailsViewModel()
    var jobID = "647"
    var jobDetails : ProviderJobDetailsData?
    private var bindings = Set<AnyCancellable>()
    var isExpanded = false
    var type : orderType = .pending
    weak var delegate : JobStstusUpdate?
    
    //MARK: - UIViewController life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        viewModel.getJobDetails(jobid: jobID)
        bindViewModel()
        addLeftBarButtonItem()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Helping Methods
    
    func initialSetup(){
        
        let nib1 = UINib(nibName: "JobDetailsTVC", bundle: nil)
        self.tbvu.register(nib1, forCellReuseIdentifier: "JobDetailsTVC")
        let nib2 = UINib(nibName: "QuesAnswerTVC", bundle: nil)
        self.tbvu.register(nib2, forCellReuseIdentifier: "QuesAnswerTVC")
        let nib3 = UINib(nibName: "HeaderCell", bundle: nil)
        self.tbvu.register(nib3, forCellReuseIdentifier: "HeaderCell")
        tbvu.separatorStyle = .none
        tbvu.showsVerticalScrollIndicator = false
        tbvu.delegate = self
        tbvu.dataSource = self
        switch type{
        case .pending:
            firstBtn.backgroundColor = UIColor.init(hexString: "#FFDBDB")
            firstBtn.setTitle("Reject".localized(), for: .normal)
            firstBtn.setTitleColor(UIColor.init(hexString: "#F50C1A"), for: .normal)
            secondBtn.backgroundColor = UIColor.init(hexString: "#D6FFC7")
            secondBtn.setTitle("Accept".localized(), for: .normal)
            secondBtn.setTitleColor(UIColor.init(hexString: "#13941D"), for: .normal)
        case .accepted:
            firstBtn.backgroundColor = UIColor.init(hexString: "#127DC6")
            firstBtn.setTitle("Additional Invoice".localized(), for: .normal)
            firstBtn.setTitleColor(UIColor.white, for: .normal)
            secondBtn.backgroundColor = UIColor.init(hexString: "#089F93")
            secondBtn.setTitle("Complete Job".localized(), for: .normal)
            secondBtn.setTitleColor(UIColor.white, for: .normal)
        case .failed:
            buttonsOuterVu.isHidden = false
            firstBtn.isHidden = true
            secondBtn.backgroundColor = UIColor.init(hexString: "#FFDBDB")
            secondBtn.setTitle("Report Problem".localized(), for: .normal)
            secondBtn.setTitleColor(UIColor.init(hexString: "#F50C1A"), for: .normal)
        case .completed:
            buttonsOuterVu.isHidden = true
        }
        
    }
    func setupAcceptedView(){
        if type == .accepted{
            if jobDetails?.is_complete_allowed == 1 {
                secondBtn.isEnabled = true
                secondBtn.layer.opacity = 1
            }else{
                secondBtn.isEnabled = false
                secondBtn.layer.opacity = 0.3
            }
            if jobDetails?.is_additional_invoice_marked == 0{
                firstBtn.isEnabled = true
                firstBtn.layer.opacity = 1
            }else{
                firstBtn.isEnabled = false
                firstBtn.layer.opacity = 0.3
            }
            
        }
    }
    private func bindViewModel() {
        viewModel.jobDetailsResult
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
            } receiveValue: { [weak self] jobdata in
                
                //
                self?.jobDetails = jobdata
                self?.tbvu.reloadData()
                
                self?.setupAcceptedView()
            }.store(in: &bindings)
        
        viewModel.$state.sink { [weak self] (state) in
            switch state {
            case .noInternet(let noInternetMsg):
                DispatchQueue.main.async {
                    self?.showAlert("Done", noInternetMsg, .warning)
                }
                break
            case .loading:
                print("Loading")
                break
            case .error(let error):
                DispatchQueue.main.async {
                    self?.showAlert("Done", error)
                }
                break
            case .loaded(let message):
                DispatchQueue.main.async { [weak self] in
                    self?.showAlert("Done", message, .success)
                    if self?.type == .pending{
                        self?.delegate?.jobStatusChange(type: orderType.accepted)
                    }else{
                        self?.delegate?.jobStatusChange(type: orderType.completed)
                    }
                    self?.navigationController?.popViewController(animated: false)
                }
                break
            case .idle:
                print("Loading")
                break
            }
        }.store(in: &bindings)
        
        
    }
    private func openMaps(lat: Double, long: Double){
        let latitude: CLLocationDegrees = lat
        let longitude: CLLocationDegrees = long
        let regionDistance:CLLocationDistance = 100
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        //        mapItem.name = K.companyName
        mapItem.openInMaps(launchOptions: options)
    }
    private func moveToRejectionController(){
        let storyboard = getProviderStoryboard()
        guard let vc = storyboard.instantiateViewController(JobRejectionVC.self) else {
            return
        }
        vc.delegate = self
        vc.serviceID = jobID
        vc.orderumber = jobDetails?.order_number ?? ""
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    private func moveToImageViewerController(images: [imagesData]){
        let storyboard = getProviderStoryboard()
        guard let vc = storyboard.instantiateViewController(ImageViewrVC.self) else {
            return
        }
        vc.images = images
        
        show(vc, sender: self)
    }
    private func moveToAddInviceController(){
        let storyboard = getProviderStoryboard()
        guard let vc = storyboard.instantiateViewController(ProviderAddInviceVC.self) else {
            return
        }
        vc.serviceID = jobID
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
        
        
    }
    
    //MARK: - UIButtons Actions
    
    override func btnBackAction() {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnTpd(_ sender: UIButton) {
        switch sender.tag{
        case 0:
            if type == .pending{
                moveToRejectionController()
            }else{
                moveToAddInviceController()
            }
        case 1:
            if type == .failed{
                self.openHelpSupport()
            }
            else if type == .pending{
                viewModel.setJobStatus(serviceID: jobID, reason: "", status: "2")
            }else{
                viewModel.setJobStatus(serviceID: jobID, reason: "", status: "4")
            }
            
        default:
            print("Do nothing")
        }
        
    }
    
    
    
}
//MARK: - UITableView Delegate

extension JobDetailsVC: UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            let count = jobDetails?.question_answers?.count ?? 0
            return (count + 1)
        }else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            //return 510
            return UITableView.automaticDimension
        }else if indexPath.section == 1 && indexPath.row == 0 && (jobDetails?.question_answers?.count ?? 0) == 0{
            return 0
        }else if indexPath.section == 1 && indexPath.row != 0 && !isExpanded{
            return 0
        }else if indexPath.section == 2 && (jobDetails?.images?.count ?? 0) == 0{
            return 0
        }else{
            return UITableView.automaticDimension
        }
        
        //        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobDetailsTVC", for: indexPath) as! JobDetailsTVC
            cell.selectionStyle = .none
            if let data = jobDetails{
                cell.configureCell(type: type, item: data)
            }
            cell.getDirectionBtn.addTarget(self, action: #selector(directionBtnTpd(sender:)), for: .touchUpInside)
            cell.InviceBtn.addTarget(self, action: #selector(inviceBtnTpd(sender:)), for: .touchUpInside)
            return cell
            
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
//<<<<<<< HEAD
            cell.configureCell(isExpanded: isExpanded, title: "View Questions".localized())
//=======
            cell.selectionStyle = .none
            
            cell.bottomSepratorVu.isHidden = false
            
            cell.LblHeader.text = "View Images".localized()
            return cell
        }else if indexPath.section == 1 && indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            cell.selectionStyle = .none
            if (jobDetails?.images?.count ?? 0) == 0{
                if !isExpanded{
                    cell.bottomSepratorVu.isHidden = false
                }else{
                    cell.bottomSepratorVu.isHidden = true
                }
            }else{
                if isExpanded{
                    cell.bottomSepratorVu.isHidden = true
                }
            }
            cell.configureCell(isExpanded: isExpanded, title: "View Questions".localized())
//>>>>>>> a53e549e5448a4c8b3b5f77f05c90ed69a7c232b
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuesAnswerTVC", for: indexPath) as! QuesAnswerTVC
            cell.selectionStyle = .none
            if let data = jobDetails?.question_answers?[indexPath.row - 1]{
                cell.configureCell(item: data)
            }
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0{
            isExpanded.toggle()
            tbvu.reloadData()
        }
        if indexPath.section == 2{
            if let images = jobDetails?.images{
                moveToImageViewerController(images: images)
            }
        }
    }
    @objc func inviceBtnTpd(sender: UIButton){
        if let data = jobDetails{
            if data.invoice_url != ""{
                let storyboard = getMainStoryboard()
                guard let VC = storyboard.instantiateViewController(InvoiceVC.self) else {
                    return
                }
                VC.invoiceUrl = data.invoice_url ?? ""
                VC.addInvoiceUrl = data.additional_invoice_url ?? ""
                
                show(VC, sender: self)
            }
        }
    }
    @objc func directionBtnTpd(sender: UIButton){
        if let data = jobDetails{
            let lat = Double(data.latitude ?? "0.0") ?? 0.0
            let long = Double(data.longitude ?? "0.0") ?? 0.0
            openMaps(lat: lat, long: long)
        }
        
    }
    
}

//MARK: - Extensions

extension JobDetailsVC: JobStstusUpdate{
    func jobStatusChange(type: orderType) {
        delegate?.jobStatusChange(type: type)
        self.navigationController?.popViewController(animated: false)
        
    }
}
extension JobDetailsVC: AdditionalInvoiceAdded{
    func addInvoiceAdded(added: Bool) {
        if added{
            viewModel.getJobDetails(jobid: jobID)
        }
    }
}
