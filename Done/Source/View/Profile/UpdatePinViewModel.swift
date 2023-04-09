//
//  UpdatePinViewModel.swift
//  Done
//
//  Created by Mazhar Hussain on 24/08/2022.
//

import Foundation
import Combine
import Localize_Swift

class UpdatePinViewModel {
    
    private var cancellables = Set<AnyCancellable>()
       let profileResult = PassthroughSubject<ProfileData, Error>()
       @Published private(set) var state = State.idle
    
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
    func updateProfile(key: String, value: String) {
        self.state = .loading
        DashboardRepo.updateCustomerProfile(key: key, value: value)
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
