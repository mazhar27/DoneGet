//
//  ProviderAddInviceVC.swift
//  Done
//
//  Created by Mazhar Hussain on 12/09/2022.
//

import UIKit
import Combine
import Localize_Swift

protocol AdditionalInvoiceAdded: AnyObject {
    func addInvoiceAdded(added: Bool)
    
}
class ProviderAddInviceVC: BaseViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var addPriceTitleLbl: UILabel!
    @IBOutlet weak var addInviceTitleLbl: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var descriptionTxtVu: UITextView!
    @IBOutlet weak var descriptionOuterVu: UIView!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var priceOuterVu: UIView!
    
    //MARK: - Variables
    
    let viewModel = ProviderAddInviceViewModel()
    private var bindings = Set<AnyCancellable>()
    var price = ""
    var remarks = ""
    var serviceID = ""
    weak var delegate : AdditionalInvoiceAdded?
    
    //MARK: - UIViewController life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        Localization()
        initialSetup()
        bindViewModel()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Helping Methods
    
    func initialSetup(){
        priceTF.delegate = self
        descriptionTxtVu.delegate = self
        priceOuterVu.layer.masksToBounds = false
        priceOuterVu.layer.shadowRadius = 4
        priceOuterVu.layer.shadowOpacity = 1
        priceOuterVu.layer.shadowColor = UIColor.gray.cgColor
        priceOuterVu.layer.shadowOffset = CGSize(width: 0 , height:2)
        priceOuterVu.layer.cornerRadius = 5
        descriptionOuterVu.layer.masksToBounds = false
        descriptionOuterVu.layer.shadowRadius = 4
        descriptionOuterVu.layer.shadowOpacity = 1
        descriptionOuterVu.layer.shadowColor = UIColor.gray.cgColor
        descriptionOuterVu.layer.shadowOffset = CGSize(width: 0 , height:2)
        descriptionOuterVu.layer.cornerRadius = 5
        enableButton(isEnable: false)
   }
    private func Localization(){
        addInviceTitleLbl.text = "Additional Invoice".localized()
        addPriceTitleLbl.text = "Add Price".localized()
        descLbl.text = "Description".localized()
        sendBtn.setTitle("Send to Customer".localized(), for: .normal)
        if Localize.currentLanguage() == "ar"{
            priceTF.textAlignment = .right
            descriptionTxtVu.textAlignment = .right
        }else{
            priceTF.textAlignment = .left
            descriptionTxtVu.textAlignment = .left
        }
    }
    func bindViewModel(){
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
                    self?.delegate?.addInvoiceAdded(added: true)
                    self?.dismiss(animated: false)
                }
                break
            case .idle:
                print("Loading")
                break
            }
        }.store(in: &bindings)
    }
    func enableButton(isEnable: Bool){
        if isEnable{
            sendBtn.backgroundColor = UIColor.blueThemeColor
            sendBtn.isEnabled = true
        }else{
            sendBtn.isEnabled = false
            sendBtn.backgroundColor = UIColor.gray
            sendBtn.setTitleColor(UIColor.white, for: .disabled)
        }
    }
    
    //MARK: - UIButtons Actions
    
    @IBAction func closeBtnTpd(_ sender: Any) {
        self.dismiss(animated: false)
    }
    @IBAction func sendBtnTpd(_ sender: Any) {
        viewModel.setJobStatus(serviceID: serviceID, price: price, remarks: remarks)
    }
    
}
//MARK: - UITextField Delegates

extension ProviderAddInviceVC: UITextFieldDelegate, UITextViewDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        price = textField.text!
        if price != "" && remarks != ""{
            enableButton(isEnable: true)
        }else{
            enableButton(isEnable: false)
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        remarks = textView.text!
        if price != "" && remarks != ""{
            enableButton(isEnable: true)
        }else{
            enableButton(isEnable: false)
        }
    }
}
