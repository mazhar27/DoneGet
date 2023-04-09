//
//  ProfileViewModel.swift
//  Done
//
//  Created by Mazhar Hussain on 01/08/2022.
//

import Foundation
import Combine

class ProfileViewModel {
    
 private var cancellables = Set<AnyCancellable>()
    let profileResult = PassthroughSubject<ProfileData, Error>()
    @Published private(set) var state = State.idle
    
    func getUserProfile() {
        DashboardRepo.getUserProfileData()
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
//                    self?.state = .error(error.localizedDescription)
                    self?.profileResult.send(completion: .failure(error))
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                if let data = result.data{
                    self?.profileResult.send(data)
                }
//                self?.state = .loaded(result.message ?? "")
            }).store(in: &cancellables)
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
    func updateProfilePic(key: String, images: [UIImage]) {
        self.state = .loading
        DashboardRepo.updateCustomerProfilePic(key: key, images: images)
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
    func validate(number: String?) -> Bool {
        guard let number = number, !number.isEmpty else {
            return false
        }
        
        if number.count > 9 || number.count < 9 {
            return false
        }
        return true
    }
}

