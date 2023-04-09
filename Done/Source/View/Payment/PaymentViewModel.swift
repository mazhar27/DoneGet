//
//  PaymentViewModel.swift
//  Done
//
//  Created by Mazhar Hussain on 24/08/2022.
//

import Foundation
import Combine

class PaymentViewModel {
    
    private var cancellables = Set<AnyCancellable>()
    let bankhostedData = PassthroughSubject<BankHostedData, Error>()
    var servicesArray = [NSMutableDictionary]()
    var couponData = [String]()
    @Published private(set) var state = State.idle
    
    
    func getBankUrl(param: [String:Any]) {
       
         
         CartRepo.getBankHostedURL(param: param)
             .sink(receiveCompletion: { [weak self] result in
                 switch result {
                 case .failure(let error):
 //                    self?.state = .error(error.localizedDescription)
                     self?.bankhostedData.send(completion: .failure(error))
                     break
                 case .finished:
                     break
                 }
             }, receiveValue: { [weak self] result in
                
                 if let bankdata = result.data {
                     print(result)
                     self?.bankhostedData.send(bankdata)
                 }
 //                self?.state = .loaded(result.message ?? "")
             }).store(in: &cancellables)
     }
    
    func topUpWallet(amount: String) {
        self.state = .loading
        let param = ["amount": amount]
        CartRepo.topUpWallet(param: param)
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
