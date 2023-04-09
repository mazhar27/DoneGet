//
//  VerifyOTPViewModel.swift
//  Done
//
//  Created by Mazhar Hussain on 6/23/22.
//

import Foundation
import Combine

class VerifyOTPViewModel {
    
    @Published private(set) var state = State.idle
    @Published private(set) var step: Int = 0
    private var cancellables = Set<AnyCancellable>()

    func verifyOTP(_ phone: String, _ otp: String, _ isForgotPin: Bool = false) {
        self.state = .loading
        OnboardingRepo.verifyOTP(phone, otp, isForgotPin)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    print("Error in OTP : \(error.errorDescription ?? "")")
                    self?.state = .error(error.errorDescription ?? "")
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                if let data = result.data {
                    print("response : \(result)")
                    self?.state = .loaded(result.message ?? "")
                    if let step = data.step {
                        self?.step = step
                    }
                    
                }
            }).store(in: &cancellables)
    }
    func verifyOTPToUpdateProfile(otp: String, pin: String) {
        self.state = .loading
        OnboardingRepo.verifyOTPUpdateProfile(pin, otp)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    print("Error in OTP : \(error.errorDescription ?? "")")
                    self?.state = .error(error.errorDescription ?? "")
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
               self?.state = .loaded(result.message ?? "")
            }).store(in: &cancellables)
    }
    
    func resendOTP(_ phone: String) {
        self.state = .loading
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
                if let _ = result.data {
                    print("response : \(result)")
                    self?.state = .loaded(result.message ?? "")
                    
                }
            }).store(in: &cancellables)
    }
    
}
