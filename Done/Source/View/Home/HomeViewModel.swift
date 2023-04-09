//
//  HomeViewModel.swift
//  Done
//
//  Created by Mazhar Hussain on 13/06/2022.
//


import Foundation
import Combine

class HomeViewModel{
    
    private var cancellables = Set<AnyCancellable>()
    let servicesResult = CurrentValueSubject<[Main_services], Error>([])
    
    func getAllServices() {
        DashboardRepo.getAllServices()
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
//                    self?.state = .error(error.localizedDescription)
                    self?.servicesResult.send(completion: .failure(error))
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                if let services = result.data?.main_services {
                    self?.servicesResult.send(services)
                }
//                self?.state = .loaded(result.message ?? "")
            }).store(in: &cancellables)
    }
    
}
