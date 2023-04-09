//
//  NoProviderVC.swift
//  Done
//
//  Created by Mazhar Hussain on 10/11/2022.
//

import UIKit
import Combine
import Localize_Swift


class NoProviderVC: BaseViewController {
    @IBOutlet weak var searchProviderLbl: UILabel!
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var datePickerTF: UITextField!
    @IBOutlet weak var descLbl: UILabel!
    
    //    MARK: - Variables
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
    
    let viewModel =  NoProviderViewModel()
    private var bindings = Set<AnyCancellable>()
    var selectedDate = ""
    var selectedTime = ""
    weak var delegate : PopAllControllers?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerTF.inputView = datePicker1
        datePickerTF.delegate = self
        datePickerTF.text = "Select date & time".localized()
        bindViewModel()
        initialSetup()
}
    private func initialSetup(){
       continueBtn.isEnabled = false
        continueBtn.backgroundColor = UIColor.gray
        continueBtn.setTitleColor(UIColor.white, for: .disabled)
        searchProviderLbl.text = "Searching Provider".localized()
        continueBtn.setTitle("Continue".localized(), for: .normal)
        descLbl.text = "Our providers are busy at the moment. Please let us know about your preferred time for service, we are finding the best provider for you.".localized()
    }
    
    private func bindViewModel() {
      
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
                   
                }
               
                self?.dismiss(animated: false, completion: {
                    self?.delegate?.ButtonTpd(isYesTpd: true)
                })
                break
            case .idle:
                print("Loading")
                break
            }
        }.store(in: &bindings)
    }
    
    
    @objc func pickerValueChanged() {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat =  "yyyy-MM-dd HH:mm"
        datePickerTF.keyboardToolbar.toolbarPlaceholder = datePicker1.date.toString()
    }
    @IBAction func closeBtnTpd(_ sender: Any) {
        self.dismiss(animated: false)
    }
   
    @IBAction func continueBtnTpd(_ sender: Any) {
        viewModel.noProviderLead(service_time: selectedTime, service_date: selectedDate, service_id:    String(SessionModel.shared.subServiceID), category_id: SessionModel.shared.categoryID, address: SessionModel.shared.location.addressTitle ?? "", option_id: SessionModel.shared.option_id)
    }
    
}


//MARK: - UITextView Delegate

extension NoProviderVC: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let dateFormatterPrint = DateFormatter()
        let datetoConvert = DateFormatter.yyyyddmmTime24Hours.string(from: datePicker1.date)
        let result = datetoConvert.split(separator: "@")
      selectedDate = String(result[0])
        selectedTime = String(result[1])
        dateFormatterPrint.dateFormat = "EEEE, MMM d, yyyy, h:mm a"
        let formatedStartDate = dateFormatterPrint.string(from: self.datePicker1.date)
        datePickerTF.text = formatedStartDate
        continueBtn.backgroundColor = UIColor.blueThemeColor
        continueBtn.isEnabled = true
//        firstLoad = false
//        viewModel.getAllProviders(providersParam: inputParameter)
    }
    //    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    //        return false
    //    }
    
}

