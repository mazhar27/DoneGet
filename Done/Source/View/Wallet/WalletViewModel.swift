//
//  WalletViewModel.swift
//  Done
//
//  Created by Mazhar Hussain on 30/08/2022.
//

import Foundation
import Combine

class WalletViewModel{
   
    private var cancellables = Set<AnyCancellable>()
    let walletSummaryResult = PassthroughSubject<WalletData, Error>()
    let transactionsSummaryResult = PassthroughSubject<WalletTransactionsData, Error>()
    
    
    func getWalletSummary() {
        SideMenuRepo.getCustomerWalletSummary()
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
//                    self?.state = .error(error.localizedDescription)
                    self?.walletSummaryResult.send(completion: .failure(error))
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                if let orders = result.data {
                    self?.walletSummaryResult.send(orders)
                }
//                self?.state = .loaded(result.message ?? "")
            }).store(in: &cancellables)
    }
    
    func getTransactonSummary() {
        SideMenuRepo.getCustomerTransactionsSummary()
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
//                    self?.state = .error(error.localizedDescription)
                    self?.transactionsSummaryResult.send(completion: .failure(error))
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                if let orders = result.data {
                    self?.transactionsSummaryResult.send(orders)
                }
//                self?.state = .loaded(result.message ?? "")
            }).store(in: &cancellables)
    }
}
