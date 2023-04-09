//
//  SignUpVC.swift
//  Done
//
//  Created by Mazhar Hussain on 07/06/2022.
//

import UIKit
import Combine
//import NotificationBannerSwift
import SwiftMessages
import Localize_Swift

class SignUpVC: BaseViewController {
    
    @IBOutlet weak var privacyLbl: UILabel!
   
    @IBOutlet weak var termsBtn: UIButton!
    @IBOutlet weak var privacyPolicyBtn: UIButton!
    @IBOutlet weak var privacyAgreeBtn: UIButton!
    @IBOutlet weak var createAccLbl: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var createAccountBtn: UIButton!
    @IBOutlet weak var codeTextField: OTPCodeTextField!
    @IBOutlet weak var createPinLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var fullNameLbl: UILabel!
    
    //MARK: - Variables
    private var pin: String?
    private var cancellables = Set<AnyCancellable>()
    var phone: String?
   
    
    //MARK: - Constants
    let viewModel = SignupViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePinField()
        bindViewModel()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
//        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    private func initialSetup(){
        emailTF.placeholder =  "e.g. johndoe@gmail.com".localized()
        nameTF.placeholder = "e.g John Doe".localized()
        self.createAccLbl.text = "Create an Account".localized()
        self.fullNameLbl.text = "Full Name".localized()
        self.createPinLbl.text = "Create 4 digit pin".localized()
        self.emailLbl.text = "Email".localized()
        self.createAccountBtn.setTitle("Create Account".localized(), for: .normal)
        self.privacyLbl.text = "I agree to".localized()
        self.privacyPolicyBtn.setTitle("Privacy Policy".localized(), for: .normal)
        
        let attributedString = NSMutableAttributedString(string: "& terms and Conditions".localized())
        attributedString.addAttributes([NSAttributedString.Key.font: UIFont.Poppins(.semibold, size: 11),
                                        NSAttributedString.Key.foregroundColor: UIColor.black],
                                       range: NSMakeRange(0,1))
        termsBtn.setAttributedTitle(attributedString, for: .normal)
       if Localize.currentLanguage() == "ar"{
           emailTF.textAlignment = .right
           nameTF.textAlignment = .right
       }
    }
    
    private func configurePinField() {
        codeTextField.defaultCharacter = ""
        codeTextField.configure()
        codeTextField.didEnterLastDigit = { [weak self] code in
            self?.pin = code
        }
    }
    
    private func bindViewModel() {
        
        viewModel.$state.sink { [weak self] (state) in
            switch state {
            case .noInternet(let noInternetMsg):
                self?.showAlertMessage(noInternetMsg, .warning)
                break
            case .error(let error):
                self?.showAlertMessage(error, .error)
                break
            case .loaded(let message):
                self?.showAlertMessage(message, .success)
                self?.setRootViewController(storyboard: Storyboards.main, identifier: "dashboardNavigator")
                break
            default:
                break
            }
        }.store(in: &cancellables)
    }
    
    private func showAlertMessage(_ message: String, _ style: Theme) {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert("Done", message, style)
        }
    }
    func privacyPolicyTapped(for isPrivacy: Bool) {
        let openTrems = Bundle.main.loadNibNamed("TremsConditionsView", owner: self, options: nil)?.first as! TremsConditionsView
        if isPrivacy {
            openTrems.comingFromTermsCondition = false
        }else{
            openTrems.comingFromTermsCondition = true
        }
        openTrems.alpha = 0
            UIView.animate(
                withDuration: 0.4,
                delay: 0.04,
                animations: {
                    openTrems.alpha = 1
                    openTrems.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                    openTrems.setLayout()
                    openTrems.delegate = self
                    self.view.addSubview(openTrems)
            })
    }
    
    //MARK: - IBActions
    @IBAction func createAccountBtnTpd(_ sender: Any) {
        
        if let validation = viewModel.validate(nameTF.text, emailTF.text, pin, privacyAgreeBtn.isSelected) {
            showAlert("Done", validation.localized(), .error)
        } else {
            guard let phoneNumber = phone, let pin = pin else {
                return
            }
            viewModel.register(nameTF.text!, emailTF.text!, phoneNumber, pin)
        }
        
    }
    
    @IBAction func agreeBtnTpd(_ sender: UIButton) {
        if sender.isSelected{
            privacyAgreeBtn.isSelected = false
            privacyAgreeBtn.setImage(UIImage(named: "uncheckedIcon"), for: .normal)
        }else{
            privacyAgreeBtn.isSelected = true
            privacyAgreeBtn.setImage(UIImage(named: "checkedIcon"), for: .normal)
        }
    }
    @IBAction func privacyPOlicyBtnTpd(_ sender: UIButton) {
        if sender.tag == 1{
            privacyPolicyTapped(for: false)
        }else{
            privacyPolicyTapped(for: true)
        }
    }
}

extension SignUpVC:TremsConditionsDelegate{
    func acceptTrems(checkAccept: Bool) {
        if checkAccept{
            privacyAgreeBtn.isSelected = true
            privacyAgreeBtn.setImage(UIImage(named: "checkedIcon"), for: .normal)
        }
    }
}
