//
//  LocationsViewModel.swift
//  Done
//
//  Created by Mazhar Hussain on 30/06/2022.
//

import Foundation
import Combine


class LocationsViewModel{
    
    private var cancellables = Set<AnyCancellable>()
    let customerAddressesResult = CurrentValueSubject<[CustomerAddress], Error>([])
    @Published private(set) var state = State.idle
  
    
    func deleteAddress(addressID: String) {
        self.state = .loading
        DashboardRepo.deleteCustomerAddresses(addressID: addressID)
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
