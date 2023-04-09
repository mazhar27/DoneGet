//
//  MyOrdersVM.swift
//  Done
//
//  Created by Mazhar Hussain on 20/06/2022.
//

import Foundation
import Combine


class MyOrdersVM {
    private var cancellables = Set<AnyCancellable>()
    let ordersResult = PassthroughSubject<CustomerOrderData, Error>()
    let providerJobsResult = PassthroughSubject<ProviderJobsData, Error>()
    
    var items = [MyOrdersModel]()
    
    func getItems() {
        
        items = [MyOrdersModel(title: "Pending".localized(), isSelected: false),MyOrdersModel(title: "Accepted".localized(), isSelected: false),MyOrdersModel(title: "Completed".localized(), isSelected: false),MyOrdersModel(title: "Failed".localized(), isSelected: false)]
        
    }
   
    func getAllServices(status: String,page: String) {
        SideMenuRepo.getCustomerOrder(status: status, page: page)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
//                    self?.state = .error(error.localizedDescription)
                    self?.ordersResult.send(completion: .failure(error))
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                if let orders = result.data {
                    self?.ordersResult.send(orders)
                }
//                self?.state = .loaded(result.message ?? "")
            }).store(in: &cancellables)
    }
    
    func getAllProviderJobs(status: String,page: String) {
        ProviderDashBoardRepo.getProviderJobsData(status: status, page: page)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
//                    self?.state = .error(error.localizedDescription)
                    self?.providerJobsResult.send(completion: .failure(error))
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                if let jobs = result.data {
                    self?.providerJobsResult.send(jobs)
                }
//                self?.state = .loaded(result.message ?? "")
            }).store(in: &cancellables)
    }
    
    
    
}
