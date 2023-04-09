//
//  AddLocationViewModel.swift
//  Done
//
//  Created by Mazhar Hussain on 29/06/2022.
//

import Foundation
import Combine

class AddLocationViewModel{
    
    private var cancellables = Set<AnyCancellable>()
    let customerAddressesResult = CurrentValueSubject<[CustomerAddress], Error>([])
    @Published private(set) var state = State.idle
    
    func saveAddress(_ model: CustomerAddress) {
        self.state = .loading
        DashboardRepo.saveCustomerAddresses(model: model)
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
    func updateAddress(_ model: CustomerAddress) {
        self.state = .loading
        DashboardRepo.updateCustomerAddresses(model: model)
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
    func validateForm() -> String{
        
        return "success"
    }
}
