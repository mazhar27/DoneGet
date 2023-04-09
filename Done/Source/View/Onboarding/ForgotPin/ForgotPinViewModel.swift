//
//  ForgotPinViewModel.swift
//  Done
//
//  Created by Mazhar Hussain on 6/28/22.
//

import Foundation
import Combine
import Localize_Swift

class ForgotPinViewModel {
    
    @Published private(set) var state = State.idle
    private var cancellables = Set<AnyCancellable>()
    
    
    func validate(_ pin: String?, _ confirmPin: String?) -> String? {
        guard let pin = pin, !pin.isEmpty else {
            return "Pin field is required".localized()
        }
        
        guard let confirmPin = confirmPin, !confirmPin.isEmpty else {
            return "Confirm Pin field is required".localized()
        }
        
        if pin != confirmPin {
            return "Create and confirm pin code does not match".localized()
        }
        
        return nil
    }
    
    func createPin(_ phone: String, _ pin: String) {
        OnboardingRepo.createPIN(phone, pin)
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
