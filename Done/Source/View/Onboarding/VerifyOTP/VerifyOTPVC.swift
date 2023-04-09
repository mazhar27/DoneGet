//
//  VerifyOTPVC.swift
//  Done
//
//  Created by Mazhar Hussain on 06/06/2022.
//

import UIKit
import Localize_Swift
import Combine

class VerifyOTPVC: BaseViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var btnResendCode: UIButton!
    @IBOutlet weak var codeTextField: OTPCodeTextField!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var verifyOTPLbl: UILabel!
    
    //MARK: - Variables
    private var cancellables = Set<AnyCancellable>()
    private var timer = Timer()
    private var duration = 120
    var phone: String?
    var isForgotPin = false
    var comeFromUpdateProfile = false
    var pin = ""
    
    //MARK: - Constants
    let viewModel = VerifyOTPViewModel()
    
    //MARK: - UIViewController life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        bindViewModel()
        configureOTPField()
        setTimer()
    }
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(false)
//      navigationController?.setNavigationBarHidden(true, animated: false)
       
    }
    
    private func initialSetup(){
        
        verifyOTPLbl.text = "Verify OTP".localized()
        detailLbl.text = "A four digit code has been sent to your entered mobile number for verification process".localized()
        btnResendCode.setTitle("Resend Code".localized(), for: .normal)
        if Localize.currentLanguage() == "ar" {
            backBtn.transform = CGAffineTransform(rotationAngle: -CGFloat.pi)
        }
        btnResendCode.isHidden = true
    }
    
    private  func setTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.duration -= 1
           
            if strongSelf.duration > 0 {

                let interval = strongSelf.duration

                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.minute, .second]
                formatter.unitsStyle = .positional
                formatter.zeroFormattingBehavior = .pad

                let formattedString = formatter.string(from: TimeInterval(interval))!
                strongSelf.timerLbl.text =  formattedString
//
            }else {
                strongSelf.duration = 120
              strongSelf.timerLbl.text = ""
                strongSelf.timer.invalidate()
               strongSelf.btnResendCode.isHidden = false
               
            }
    
        })
    }
   
    
    private func configureOTPField() {
        codeTextField.defaultCharacter = ""
        codeTextField.configure()
        if comeFromUpdateProfile{
            codeTextField.didEnterLastDigit = { [weak self] code in
                guard let self = self else {
                    return
                }
                if code.isEmpty || code.count < 4 {
                    return
                }
               
                self.codeTextField.resignFirstResponder()
               self.viewModel.verifyOTPToUpdateProfile(otp: code, pin: self.pin)
                
            }
            
        }else{
        codeTextField.didEnterLastDigit = { [weak self] code in
            guard let self = self else {
                return
            }
            guard let phone = self.phone else {
                return
            }
            if code.isEmpty || code.count < 4 {
                return
            }
            self.codeTextField.resignFirstResponder()
            self.viewModel.verifyOTP(phone, code, self.isForgotPin)
            
        }
        }
    }
    
    private func bindViewModel() {
        viewModel.$state.sink { [weak self] (state) in
            switch state {
            case .noInternet(let noInternetMsg):
                DispatchQueue.main.async {
                    self?.showAlert("Done".localized(), noInternetMsg, .warning)
                }
                break
            case .loading:
                print("Loading")
                break
            case .error(let error):
                DispatchQueue.main.async {
                    self?.showAlert("Done".localized(), error)
                }
                break
            case .loaded(let message):
                DispatchQueue.main.async {
                    self?.showAlert("Done".localized(), message, .success)
                   
                    if self?.comeFromUpdateProfile == true {
                      
                        self?.navigationController?.popToViewController(ofClass: ProfileVC.self)
                    }
                }
                break
            case .idle:
                print("Loading")
                break
            }
        }.store(in: &cancellables)
        
        viewModel.$step.sink { [weak self] (step) in
            switch step {
            case 1:
                //basic info screen for new user
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "RegisterSegue", sender: self)
                }
                break
            case 3:
                //existing user where user set a pin
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "newPinSegue", sender: self)
                }
                break
            case 4:
                //login screen where user enter pin for login
                DispatchQueue.main.async {
                    self?.navigateLogin()
                }
                break
            default:
                break
            }
        
        }.store(in: &cancellables)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RegisterSegue" {
            if let viewController = segue.destination as? SignUpVC {
                guard let phoneNumber =  phone else {
                    return
                }
                viewController.phone = phoneNumber
            }
        } else if segue.identifier == "newPinSegue" {
            if let viewController = segue.destination as? ForgotPinVC {
                guard let phoneNumber =  phone else {
                    return
                }
                viewController.phone = phoneNumber
                viewController.existingUser = true
            }
        }
        
    }
    
    private func navigateLogin() {
        UserDefaults.phoneNumber = self.phone
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController.isKind(of: LoginVC.self) {
                    self.navigationController?.popToViewController(viewController, animated: true)
                    return
                }
            }
        }
        pushLogin()
    }
    
    private func pushLogin() {
        let onBoardingStoryboard = UIStoryboard(name: Storyboards.onBoarding, bundle: nil)
        guard let loginVC = onBoardingStoryboard.instantiateViewController(withIdentifier:
                                                                                    "LoginVC") as? LoginVC else {
            return
        }
        self.show(loginVC, sender: self)
    }
    
    //MARK: - UIButton actions
    @IBAction func btnResendCodeAction(_ sender: UIButton) {
        print("Rsend code")
        guard let phone = phone else {
            return
        }

        viewModel.resendOTP(phone)
        btnResendCode.isHidden = true
        setTimer()
        
    }

    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

