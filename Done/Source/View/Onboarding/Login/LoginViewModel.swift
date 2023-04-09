//
//  LoginViewModel.swift
//  Done
//
//  Created by Mazhar Hussain on 6/27/22.
//

import Foundation
import Combine

class LoginViewModel {
    
    @Published private(set) var state = State.idle
    private var cancellables = Set<AnyCancellable>()
    
    func validate(_ pin: String?) -> Bool {
        guard let pin = pin, !pin.isEmpty else {
            return false
        }
        
        return true
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
    
    func forgorPin(_ phone: String) {
        OnboardingRepo.resendOTP(phone)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.state = .error(error.errorDescription ?? "")
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                self?.state = .loaded(result.message ?? "")
            }).store(in: &cancellables)
    }
    
}
