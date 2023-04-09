//
//  ProviderProfileVM.swift
//  Done
//
//  Created by Dtech Mac on 12/09/2022.
//

import Foundation
import Combine

class ProviderProfileViewModel {
    
 private var cancellables = Set<AnyCancellable>()
    let providerProfileResult = PassthroughSubject<ProfileInnerData, Error>()
    @Published private(set) var state = State.idle
    @Published private(set) var message = ""
    
    func getUserProfile() {
        providerProfileRepo.getProviderProfileData()
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.providerProfileResult.send(completion: .failure(error))
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                if let data = result.data{
                    self?.providerProfileResult.send(data)
                }
            }).store(in: &cancellables)
    }
    func logout() {
        self.state = .loading
        OnboardingRepo.logout()
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.state = .error(error.errorDescription ?? "")
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                print("response : \(result)")
                self?.state = .loaded(result.message ?? "")
                
            }).store(in: &cancellables)
    }
    func deleteProviderAccount(pin: String) {
        self.state = .loading
        providerProfileRepo.deleteProviderAccount(pin: pin)
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
                    if result.code == 200{
                    self?.message = result.message ?? ""
                    }else{
                        self?.state = .error(result.message ?? "")
                    }
                }
            }).store(in: &cancellables)
    }
}
