//
//  ProviderAddInviceViewModel.swift
//  Done
//
//  Created by Mazhar Hussain on 13/09/2022.
//

import Foundation
import Combine

class ProviderAddInviceViewModel{
   
    private var cancellables = Set<AnyCancellable>()
    @Published private(set) var state = State.idle
    
    func setJobStatus(serviceID: String, price: String,remarks: String) {
        self.state = .loading
        ProviderDashBoardRepo.providerAdditionalInvoice(orderServiceID: serviceID, price: price, remarks: remarks)
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
