//
//  NoProviderViewModel.swift
//  Done
//
//  Created by Mazhar Hussain on 10/11/2022.
//

import Foundation
import Combine

class NoProviderViewModel{
    
    private var cancellables = Set<AnyCancellable>()
 @Published private(set) var state = State.idle
    
    func noProviderLead(service_time : String, service_date: String,service_id:String,category_id:String,address: String,option_id: [Int]) {
        self.state = .loading
        DashboardRepo.noProviderLead(service_time: service_time, service_date: service_date, service_id: service_id, category_id: category_id, address: address, option_id: option_id)
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
