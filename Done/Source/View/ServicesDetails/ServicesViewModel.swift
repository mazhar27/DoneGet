//
//  ServicesViewModel.swift
//  Done
//
//  Created by Mazhar Hussain on 07/07/2022.
//

import Foundation
import Combine

class ServicesViewModel{
    
    private var cancellables = Set<AnyCancellable>()
    let categoriesResult = CurrentValueSubject<[Categories], Error>([])
    
    func getAllCategories(serviceID: String) {
        DashboardRepo.getServicesCategories(serviceId: serviceID)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
//                    self?.state = .error(error.localizedDescription)
                    self?.categoriesResult.send(completion: .failure(error))
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                if let services = result.data?.categories {
                    self?.categoriesResult.send(services)
                }
//                self?.state = .loaded(result.message ?? "")
            }).store(in: &cancellables)
    }
    
}
