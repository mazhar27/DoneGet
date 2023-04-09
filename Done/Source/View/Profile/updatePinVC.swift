//
//  updatePinVC.swift
//  Done
//
//  Created by Mazhar Hussain on 24/08/2022.
//

import UIKit
import Combine
import Localize_Swift

class updatePinVC: BaseViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var confirmPinBtn: UIButton!
    @IBOutlet weak var pinOTP: OTPCodeTextField!
    @IBOutlet weak var createPinTitleLbl: UILabel!
    @IBOutlet weak var confirmPinOTP: OTPCodeTextField!
    @IBOutlet weak var confirmPinTitleLbl: UILabel!
    private var bindings = Set<AnyCancellable>()
    
    //MARK: - Variables
   
    private var newPin: String?
    private var confirmPin: String?
    
    let viewModel = UpdatePinViewModel()
    
    //MARK: - UIViewController life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureOTPField()
        addLeftBarButtonItem()
        self.title = "Change Login Pin".localized()
        createPinTitleLbl.text = "Create New Pin".localized()
        confirmPinTitleLbl.text = "Confirm New Pin".localized()
        confirmPinBtn.setTitle("Change Pin".localized(), for: .normal)
        bindViewModel()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
   
        super.viewWillAppear(false)
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
                self?.movetoCOntroller()
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
    private func configureOTPField() {
        pinOTP.defaultCharacter = ""
        pinOTP.configure()
        pinOTP.didEnterLastDigit = { [weak self] code in
            self?.newPin = code
        }
        
        // Confirm pin
        confirmPinOTP.defaultCharacter = ""
        confirmPinOTP.configure()
        confirmPinOTP.didEnterLastDigit = { [weak self] code in
            self?.confirmPin = code
        }
    }
    private func movetoCOntroller(){
        let storyboard = self.getOnboardingStoryboard()
        guard let numberVC = storyboard.instantiateViewController(VerifyOTPVC.self) else {
            return
        }
        numberVC.comeFromUpdateProfile = true
        numberVC.pin = newPin ?? ""
        self.show(numberVC, sender: self)
        
    }
    
    @IBAction func confirmPinBtnTpd(_ sender: Any) {
        
        
        if let validation = viewModel.validate(newPin, confirmPin) {
            showAlert("Done".localized(), validation, .error)
        } else {
            viewModel.updateProfile(key: "4", value: newPin ?? "")
        }
    }
    
    
}
