//
//  ProvidersListVC.swift
//  Done
//
//  Created by Mazhar Hussain on 16/06/2022.
//

import UIKit
import iOSDropDown
import Combine
import Localize_Swift
import EzPopup

protocol PopAllControllers: AnyObject {
    func ButtonTpd(isYesTpd:Bool)
   
   
}


class ProvidersListVC: BaseViewController, UITextFieldDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var datePicker: UITextField!
    @IBOutlet weak var filtersDropDown: DropDown!
    @IBOutlet weak var dateOuterVu: UIView!
    @IBOutlet weak var filtersOuterVu: UIView!
   @IBOutlet weak var filtersTextLbl: UILabel!
    @IBOutlet weak var tableVu: UITableView!
    
    //    MARK: - Variables
    
    var inputParameter = ProvidersListParameterModel(date: "", sort_price_dsc: "", sort_price_asc: "", sort_rating: "", latitude: SessionModel.shared.location.latitude ?? "31.5023595", service_type: SessionModel.shared.serviceType.rawValue, category_id: SessionModel.shared.categoryID, options: [], time: "", longitude: SessionModel.shared.location.longitude ?? "74.3230744")
    var providersData = [Providers]()
    var ooptionIds : [Int] = []
    let viewModel =  ProvidersListViewModel()
    private var bindings = Set<AnyCancellable>()
    let datePicker1:UIDatePicker = {
        var dp = UIDatePicker()
        dp.minimumDate = Date()
        dp.maximumDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())
        dp.locale = Locale(identifier: "en")
        dp.translatesAutoresizingMaskIntoConstraints = false
        dp.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
        dp.datePickerMode = .dateAndTime
        if #available(iOS 13.4, *) { dp.preferredDatePickerStyle = .wheels }
        dp.addTarget(nil, action: #selector(pickerValueChanged), for: .valueChanged)
        return dp
    }()
    
    var firstLoad = true
    
    
    //MARK: - UIViewController life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = SessionModel.shared.location
        
        initialSetup()
        addLeftBarButtonItem()
        self.title = "Providers List".localized()
        datePicker.inputView = datePicker1
        datePicker.delegate = self
        //        inputParameter.options = ooptionIds
        viewModel.getAllProviders(providersParam: inputParameter)
        bindViewModel()
        // Do any additional setup after loading the view.
    }
    deinit{
        print("ProvidersListVC deinitilized")
    }
    //MARK: - Helping Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if  UserDefaults.LoginUser == nil{
            UserDefaults.userType = .guest
        }
    }
    
    private func bindViewModel() {
        viewModel.providersResult
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
            } receiveValue: { [weak self] providers in
                self?.providersData = providers
                self?.tableVu.reloadData()
                if self?.providersData.count == 0{
                    self?.showNoProvider()
                }
            }.store(in: &bindings)
     
    }
    
    private func initialSetup(){
        setupFiltersDropDown()
        dateOuterVu.layer.masksToBounds = false
        filtersOuterVu.layer.masksToBounds = false
        datePicker.text = "Select date & time".localized()
        let nib1 = UINib(nibName: "ProvidersListTVC", bundle: nil)
        self.tableVu.register(nib1, forCellReuseIdentifier: "ProvidersListTVC")
        tableVu.separatorStyle = .none
        tableVu.delegate = self
        tableVu.dataSource = self
        if Localize.currentLanguage() == "ar"{
            filtersDropDown.textAlignment = .right
        }else{
            filtersDropDown.textAlignment = .left
        }
    }
    private func setupFiltersDropDown(){
        filtersDropDown.arrowColor = UIColor.blueThemeColor
        filtersDropDown.optionArray = ["Low to high".localized(), "High to low".localized()]
        filtersDropDown.text = filtersDropDown.optionArray[0]
        filtersDropDown.didSelect{ [unowned self](selectedText , index ,id) in
            //            self.filtersDropDown.text = ""
            
            if index == 0{
                inputParameter.sort_price_asc = "1"
                inputParameter.sort_price_dsc = "0"
                firstLoad = false
                viewModel.getAllProviders(providersParam: inputParameter)
            }else{
                inputParameter.sort_price_asc = "0"
                inputParameter.sort_price_dsc = "1"
                firstLoad = false
                viewModel.getAllProviders(providersParam: inputParameter)
            }
            self.filtersDropDown.text = ""
        }
        
    }
    private func showNoProvider(){
        if UserDefaults.userType != .guest {
            let storyboard = getMainStoryboard()
                   guard let numberVC = storyboard.instantiateViewController(NoProviderVC.self) else {
                       return
                   }
            numberVC.delegate = self
             let popupVC = PopupViewController(contentController: numberVC, popupWidth: UIScreen.main.bounds.width - 20, popupHeight: 450)
          
            present(popupVC, animated: true)
           
        }else{
            UserDefaults.comigFromNoProvider = true
            UserDefaults.userType = .customer
            let storyboard = getOnboardingStoryboard()
        if let _ = UserDefaults.phoneNumber {
          guard let numberVC = storyboard.instantiateViewController(LoginVC.self) else {
                return
            }
            numberVC.comeFromNoProvider = true
           show(numberVC, sender: self)
        }else {
          guard let numberVC = storyboard.instantiateViewController(VerifyPhoneVC.self) else {
                  return
              }
             show(numberVC, sender: self)
        }
        }
       
    }
    
    private func getAttributedText(title: String)->NSMutableAttributedString{
        let sortedByString = "Sort by: ".localized()
        let attributedString = NSMutableAttributedString(string: "\(sortedByString) \(title)")
        attributedString.addAttributes([NSAttributedString.Key.font: UIFont.Poppins(.regular, size: 16),
                                        NSAttributedString.Key.foregroundColor: UIColor.labelTitleColor],
                                       range: NSMakeRange(0, 8))
        return attributedString
    }
    
    @objc func pickerValueChanged() {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat =  "yyyy-MM-dd HH:mm"
        datePicker.keyboardToolbar.toolbarPlaceholder = datePicker1.date.toString()
    }
    
    //MARK: - IBActions
    
    @IBAction func datePickerBtnTpd(_ sender: Any) {
    }
    
    
}

//MARK: - UITableView Delegate

extension ProvidersListVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if providersData.count == 0 {
            self.tableVu.setEmptyMessage("No data found".localized())
        } else {
            self.tableVu.restore()
        }
        return providersData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProvidersListTVC", for: indexPath) as! ProvidersListTVC
        cell.configureCell(provider: providersData[indexPath.row])
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let id = providersData[indexPath.row].provider_id{
            SessionModel.shared.providerID = id
        }
        if let name = providersData[indexPath.row].provider_detail?.name{
            SessionModel.shared.providerName = name
        }
        if let price = providersData[indexPath.row].service_price{
            SessionModel.shared.servicePrice = String(price)
        }
        
        let storyboard = getMainStoryboard()
        guard let numberVC = storyboard.instantiateViewController(providersDetailVC.self) else {
            return
        }
        //        numberVC.providerID = providersData[indexPath.row].provider_id ?? ""
        //        numberVC.serviceID = providersData[indexPath.row].service_id ?? ""
        show(numberVC, sender: self)
    }
    
    
}
//MARK: - UITextView Delegate

extension ProvidersListVC: UITextViewDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        let dateFormatterPrint = DateFormatter()
        let datetoConvert = DateFormatter.yyyyddmmTime12Hours.string(from: datePicker1.date)
        let result = datetoConvert.split(separator: "@")
        inputParameter.date = String(result[0])
        inputParameter.time = String(result[1])
        dateFormatterPrint.dateFormat = "MMM d, h:mm a"
        let formatedStartDate = dateFormatterPrint.string(from: self.datePicker1.date)
        datePicker.text = formatedStartDate
        firstLoad = false
        viewModel.getAllProviders(providersParam: inputParameter)
    }
    //    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    //        return false
    //    }
    
}
extension ProvidersListVC: PopAllControllers{
    func ButtonTpd(isYesTpd: Bool) {
        if isYesTpd{
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
    

}




