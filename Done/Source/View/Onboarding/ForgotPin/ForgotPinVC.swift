//
//  ForgotPinVC.swift
//  Done
//
//  Created by Mazhar Hussain on 06/06/2022.
//

import UIKit
import Combine
import Localize_Swift
//import NotificationBannerSwift
import SwiftMessages

class ForgotPinVC: BaseViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var txtNewPin: OTPCodeTextField!
    @IBOutlet weak var txtConfirmPin: OTPCodeTextField!
    @IBOutlet weak var confirmPinLbl: UILabel!
    @IBOutlet weak var createNewPinLbl: UILabel!
    @IBOutlet weak var forgotPinLbl: UILabel!
    
    //MARK: - Variables
    var phone: String?
    private var newPin: String?
    private var confirmPin: String?
    private var cancellables = Set<AnyCancellable>()
    var existingUser = false
    
    //MARK: - Constants
    let viewModel = ForgotPinViewModel()
    
    //MARK: - UIViewController life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        configureOTPField()
        bindViewModel()
        Localization()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    private func Localization(){
        forgotPinLbl.text = "Create your new pin".localized()
        createNewPinLbl.text = "Create New Pin".localized()
        confirmPinLbl.text = "Confirm New Pin".localized()
        proceedBtn.setTitle("Update Pin".localized(), for: .normal)
        if Localize.currentLanguage() == "ar"{
            self.backBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }else{
            self.backBtn.transform = .identity
        }
    }
    
    private func initialSetup(){
        backBtn.setTitle("", for: .normal)
        if existingUser{
            forgotPinLbl.text = "Create your new pin".localized()
        }
    }
    
    private func configureOTPField() {
        txtNewPin.defaultCharacter = ""
        txtNewPin.configure()
        txtNewPin.didEnterLastDigit = { [weak self] code in
            self?.newPin = code
        }
        
        // Confirm pin
        txtConfirmPin.defaultCharacter = ""
        txtConfirmPin.configure()
        txtConfirmPin.didEnterLastDigit = { [weak self] code in
            self?.confirmPin = code
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
                if UserDefaults.userType == .provider{
                    self?.setRootViewController(storyboard: Storyboards.provider, identifier: "ProviderNav")
                }else{
                   self?.setRootViewController(storyboard: Storyboards.main, identifier: "dashboardNavigator")
                }
                break
            default:
                break
            }
        }.store(in: &cancellables)
    }
    
    private func showAlertMessage(_ message: String, _ style: Theme) {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert("Done".localized(), message, style)
        }
    }
    
    //MARK: - IBActions
    @IBAction func proceedBtnTpd(_ sender: Any) {
        if let validation = viewModel.validate(newPin, confirmPin) {
            showAlert("Done".localized(), validation, .error)
        } else {
            guard let phone = phone, let pin = newPin else
            {return }
            viewModel.createPin(phone, pin)
        }
        
    }
    
    @IBAction func backBtnTpd(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
