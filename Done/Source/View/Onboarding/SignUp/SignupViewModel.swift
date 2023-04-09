//
//  SignupViewModel.swift
//  Done
//
//  Created by Mazhar Hussain on 6/27/22.
//

import Foundation
import Combine
import Localize_Swift

class SignupViewModel {
    
    @Published private(set) var state = State.idle
    private var cancellables = Set<AnyCancellable>()

    func validate(_ name: String?, _ email: String?, _ pin: String?, _ privacypolicy: Bool?) -> String? {
        guard let full_name = name, !full_name.isEmpty else {
            return "Name field is required".localized()
        }
        
        guard let email = email, !email.isEmpty else {
            return "Email field is required".localized()
        }
        if !email.isValidWith(regexType: .email) {
            return "Please enter a valid email address".localized()
        }
        
        guard let pin = pin, !pin.isEmpty else {
            return "Pin field is required".localized()
        }
        guard let privacypolicy = privacypolicy, privacypolicy == true else {
            return "Please Accept Terms & Conditions".localized()
        }
        if pin.count < 4 {
            return "Please enter a valid pin".localized()
        }
        return nil
    }
    
    func register(_ name: String, _ email: String, _ phone: String, _ pin: String) {
        OnboardingRepo.register(name, email, number: phone, pin)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.state = .error(error.errorDescription ?? "")
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                //self?.state = .loaded(result.message ?? "")
                self?.login(phone, pin)
            }).store(in: &cancellables)
    }
    
    func login(_ phone: String, _ pin: String) {
        OnboardingRepo.login(phone, pin)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.state = .error(error.errorDescription ?? "")
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                if var userModel = result.data {
                    if let token = userModel.token {
                        KeychainHelper.standard.save(token, account: Constants.Strings.token)
                    }
                    userModel.token = nil
                    UserDefaults.LoginUser = userModel
                    UserDefaults.isLogined = true
                }
                self?.state = .loaded(result.message ?? "")
            }).store(in: &cancellables)
    }
}
