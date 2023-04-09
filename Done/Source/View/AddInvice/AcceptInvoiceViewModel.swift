//
//  AcceptInvoiceViewModel.swift
//  Done
//
//  Created by Mazhar Hussain on 01/09/2022.
//

import Foundation
import Combine

class AcceptInvoiceViewModel{
    
    private var cancellables = Set<AnyCancellable>()
    let addInvoiceResult = PassthroughSubject<[AdditionalInvoiceData], Error>()
    @Published private(set) var state = State.idle
    
    func changeAddInviceStatus(status: String,addCostId: String, transactionID: String) {
        self.state = .loading
        SideMenuRepo.changeAdditionalInvoiceStatus(status: status, addCostId: addCostId, transId: transactionID)
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
