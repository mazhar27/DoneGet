//
//  VerifyPhoneViewModel.swift
//  Done
//
//  Created by Mazhar Hussain on 6/15/22.
//

import Foundation
import Combine

class VerifyPhoneViewModel {
    
    @Published private(set) var state = State.idle
    private var cancellables = Set<AnyCancellable>()
    
    func validate(number: String?) -> Bool {
        guard let number = number, !number.isEmpty else {
            return false
        }
        
        if number.count > 9 || number.count < 9 {
            return false
        }
        return true
    }
    
    func verifyPhone(_ phone: String) {
        self.state = .loading
        OnboardingRepo.verifyPhone(phone)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.state = .error(error.errorDescription ?? "")
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                if let data = result.data {
                    print("response : \(result)")
                    print(data)
                    self?.state = .loaded(result.message ?? "")
                }
            }).store(in: &cancellables)
    }
    
}
