//
//  SignUpVC.swift
//  Done
//
//  Created by Mazhar Hussain on 06/06/2022.
//

import UIKit
import Localize_Swift
import Combine

class VerifyPhoneVC: BaseViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var btnGuest: UIButton!
    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var mobileNumberLbl: UILabel!
    @IBOutlet weak var createAccountLbl: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var imageViewSeperatorView: UIView!
    @IBOutlet weak var flagTextFieldContainerView: UIView!
    
    //MARK: - Constants
    let viewModel = VerifyPhoneViewModel()
    
    //MARK: - Variables
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - UIViewController life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        bindViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureGuestButton()
        
    }
    
    private func configureGuestButton() {
        if UserDefaults.userType.rawValue == 1 {
            btnGuest.isHidden = false
        }else {
            btnGuest.isHidden = true
        }
    }
    
    private func initialSetup(){
        if Localize.currentLanguage() == "ar"{
            self.numberTF.textAlignment = .right
        }else{
            self.numberTF.textAlignment = .left
        }
        numberTF.delegate = self
        createAccountLbl.text = "Login / SignUp to your account".localized()
        proceedBtn.setTitle("Proceed".localized(), for: .normal)
        btnGuest.setTitle("Continue as Guest".localized(), for: .normal)
        mobileNumberLbl.text = "Mobile Number".localized()
    }
    
    private func textLimit(existingText: String?,
                           newText: String,
                           limit: Int) -> Bool {
        let text = existingText ?? ""
        let isAtLimit = text.count + newText.count <= limit
        return isAtLimit
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
                    print("Message: \(message)")
//                    self?.showAlert("Done", message, .success)
                    self?.performSegue(withIdentifier: "verifyOTPSegue", sender: self)
                }
                break
            case .idle:
                print("Loading")
                break
            }
        }.store(in: &cancellables)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? VerifyOTPVC {
            guard let phone =  numberTF.text else {
                return
            }
            viewController.phone = phone
        }
    }
    
    //MARK: - IBActions
    @IBAction func proceedBtnTpd(_ sender: Any) {
        if viewModel.validate(number: numberTF.text) {
    
            viewModel.verifyPhone(numberTF.text!)
        }else {
            showAlert("Done".localized(), "The phone number must have 9 digits".localized(), .error)
        }
    }
    
    @IBAction func backBtnTpd(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func btnGuestAction(_ sender: Any) {
        UserDefaults.isLogined = true
        UserDefaults.userType = .guest
        self.setRootViewController(storyboard: Storyboards.main, identifier: "dashboardNavigator")
    }
}


//MARK: - UITextFieldDelegate
extension VerifyPhoneVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return self.textLimit(existingText: textField.text,
                              newText: string,
                              limit: 9)
    }
    
}
