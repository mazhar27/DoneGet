//
//  EditProfileVC.swift
//  Done
//
//  Created by Mazhar Hussain on 27/06/2022.
//

import UIKit
import Combine
import Localize_Swift

class EditProfileVC: BaseViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var inputTFOuterVu: UIView!
    @IBOutlet weak var numberOuterVu: UIView!
    @IBOutlet weak var inputTF: UITextField!
    
    //    MARK: - Variables
    
    var titleText = ""
    var dataText = ""
    var controllerTitle = ""
    var key = "0"
    let viewModel =  ProfileViewModel()
    private var bindings = Set<AnyCancellable>()
    
    //MARK: - UIViewController life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLeftBarButtonItem()
        initialSetup()
        bindViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
    }
    
    private func initialSetup(){
        numberOuterVu.isHidden = true
        self.title = controllerTitle
        titleLbl.text = titleText
        inputTF.text = dataText
        saveBtn.setTitle("Save".localized(), for: .normal)
        if key == "3"{
            numberTF.delegate = self
            inputTFOuterVu.isHidden = true
            numberOuterVu.isHidden = false
            numberTF.placeholder = dataText
            saveBtn.setTitle("Verify".localized(), for: .normal)
        }
        if key == "2"{
            saveBtn.setTitle("Verify".localized(), for: .normal)
        }
        if Localize.currentLanguage() == "ar"{
            numberTF.textAlignment = .right
            inputTF.textAlignment = .right
        }else{
            numberTF.textAlignment = .left
            inputTF.textAlignment = .left
        }
    }
    private func movetoEmailController(){
        let storyboard = self.getMainStoryboard()
        guard let numberVC = storyboard.instantiateViewController(EmailVerificationVC.self) else {
            return
        }
        self.show(numberVC, sender: self)
        
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
                self?.navigationController?.popViewController(animated: true)
                break
            case .loaded(let message):
                switch self?.key{
                case "1":
                    UserDefaults.LoginUser?.name = self?.inputTF.text!
                    self?.navigationController?.popViewController(animated: true)
                case "2":
                    UserDefaults.LoginUser?.email = self?.inputTF.text!
                    self?.movetoEmailController()
                case "3":
                    let storyboard = self?.getOnboardingStoryboard()
                    guard let numberVC = storyboard?.instantiateViewController(VerifyOTPVC.self) else {
                        return
                    }
                    numberVC.comeFromUpdateProfile = true
                    self?.show(numberVC, sender: self)
                default:
                    print("")
                }
                DispatchQueue.main.async { [weak self] in
                    self?.showAlert("Done".localized(), message, .success)
                }
                break
            case .idle:
                print("Loading")
                break
            }
        }.store(in: &bindings)
    }
    private func textLimit(existingText: String?,
                           newText: String,
                           limit: Int) -> Bool {
        let text = existingText ?? ""
        let isAtLimit = text.count + newText.count <= limit
        return isAtLimit
    }
    
    //MARK: - IBActions
    
    @IBAction func saveBtnTpd(_ sender: Any) {
        switch key {
        case "1","2":
            viewModel.updateProfile(key: key, value: inputTF.text!)
        case "3":
            if viewModel.validate(number: numberTF.text) {
                viewModel.updateProfile(key: key, value: Constants.Strings.countryCode + numberTF.text!)
            }else {
                showAlert("Done".localized(), "The phone number must have 9 digits".localized(), .error)
            }
            
        default:
            print("")
        }
        
        
    }
    
    
}

//MARK: - UITextFieldDelegate
extension EditProfileVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return self.textLimit(existingText: textField.text,
                              newText: string,
                              limit: 9)
    }
    
}
