//
//  LoginVC.swift
//  Done
//
//  Created by Mazhar Hussain on 03/06/2022.
//

import UIKit
import Combine
import Localize_Swift
//import NotificationBannerSwift
import SwiftMessages

class LoginVC: BaseViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var loginWithDiffAccBtn: UIButton!
    @IBOutlet weak var loginToAccountLbl: UILabel!
    @IBOutlet weak var enterPinLbl: UILabel!
    @IBOutlet weak var loginDifferentAccLbl: UILabel!
    @IBOutlet weak var forgotPinLbl: UILabel!
    @IBOutlet weak var forgotPinBtn: UIButton!
    @IBOutlet weak var dontHaveAccLbl: UILabel!
    @IBOutlet weak var pinView: SMPinView!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var continueGuestBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var backBtn: UIButton!
    // Variables
    private var cancellables = Set<AnyCancellable>()
    private var phone: String?
    var userType: UserType = .guest
    var isForgotPin = false
    var comeFromNoProvider = false
    
    
    //MARK: - Constants
    let viewModel = LoginViewModel()
    
    //MARK: - UIViewController life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        localizeStrings()
        bindViewModel()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: false)
        
        if let phoneNumber = UserDefaults.phoneNumber {
            phone = phoneNumber
            forgotPinBtn.isEnabled = true
        }else {
            forgotPinBtn.isEnabled = false
        }
        if UserDefaults.userType == .provider{
            signUpBtn.isHidden = true
        }
        if let number = UserDefaults.phoneNumber{
        phoneNumberLbl.text = "+966" + number
        }
        if let phone = phone{
            if phone != ""{
            phoneNumberLbl.text = "+966" + phone
            }
        }
        if comeFromNoProvider{
            backBtn.isHidden = true
        }
    }
    private func initialSetup(){
       
        if UserDefaults.userType == .provider {
            continueGuestBtn.isHidden = true
            dontHaveAccLbl.isHidden = true
        }
    }
    
    private func localizeStrings(){
        forgotPinBtn.setTitle("", for: .normal)
        loginWithDiffAccBtn.setTitle("", for: .normal)
        loginToAccountLbl.text = "Login to your account".localized()
        enterPinLbl.text = "Enter your 4 digit pin to proceed".localized()
        loginBtn.setTitle("Login".localized(), for: .normal)
        forgotPinLbl.text = "Forgot Your Pin?".localized()
        continueGuestBtn.setTitle("Continue as Guest".localized(), for: .normal)
        loginDifferentAccLbl.text = "Login with different account instead".localized()
        dontHaveAccLbl.text = "Don’t have an account?".localized()
        signUpBtn.setTitle("Sign Up".localized(), for: .normal)
        
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
                guard let self = self else {return}
                if self.isForgotPin {
                    self.performSegue(withIdentifier: "pinVerifySegue", sender: self)
                }else {
                    if UserDefaults.userType == .customer{
                      
                    self.setRootViewController(storyboard: Storyboards.main, identifier: "dashboardNavigator")
                    }else{
                        self.setRootViewController(storyboard: Storyboards.provider, identifier: "ProviderNav")
                    }
                }
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pinVerifySegue" {
            if let viewcontroller = segue.destination as? VerifyOTPVC{
                viewcontroller.phone = phone
                viewcontroller.isForgotPin = true
            }
        }
    }
    
    //MARK: - IBActions
    @IBAction func loginBtnTpd(_ sender: Any) {
        UserDefaults.isLogined = false
        if pinView.getPinViewText().count == 4 {
            guard let phoneNumber = phone else {
                return
            }
            isForgotPin = false
            viewModel.login(phoneNumber, pinView.getPinViewText())
        }else {
            showAlert("Done", "Pin field is required".localized(), .error)
        }
    }
    @IBAction func backBtnTpd(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func continueGuestBtnTpd(_ sender: Any) {
        UserDefaults.isLogined = true
        UserDefaults.userType = .guest
        self.setRootViewController(storyboard: Storyboards.main, identifier: "dashboardNavigator")
    }
    
    @IBAction func btnForgotAction(_ sender: UIButton) {
        guard let phoneNumber = phone else {
            return
        }
        isForgotPin = true
        viewModel.forgorPin(phoneNumber)
    }
}
