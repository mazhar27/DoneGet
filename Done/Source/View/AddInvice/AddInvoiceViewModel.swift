//
//  AddInvoiceViewModel.swift
//  Done
//
//  Created by Mazhar Hussain on 30/08/2022.
//

import Foundation
import Combine


class AddInvoiceViewModel{
    
    private var cancellables = Set<AnyCancellable>()
    let addInvoiceResult = PassthroughSubject<[AdditionalInvoiceData], Error>()
    @Published private(set) var state = State.idle
  
    
    func getInvoiceSummary() {
        SideMenuRepo.getCustomerAddInvoice()
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
//                    self?.state = .error(error.localizedDescription)
                    self?.addInvoiceResult.send(completion: .failure(error))
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                if let orders = result.data {
                    self?.addInvoiceResult.send(orders)
                }
//                self?.state = .loaded(result.message ?? "")
            }).store(in: &cancellables)
    }
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
