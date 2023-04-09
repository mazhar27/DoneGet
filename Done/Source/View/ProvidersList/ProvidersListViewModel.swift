//
//  ProvidersListViewModel.swift
//  Done
//
//  Created by Mazhar Hussain on 20/07/2022.
//

import Foundation
import Combine

class ProvidersListViewModel {
    
    private var cancellables = Set<AnyCancellable>()
    let providersResult = PassthroughSubject<[Providers], Error>()
 

    
    func getAllProviders(providersParam: ProvidersListParameterModel) {
        DashboardRepo.getProvidersList(model: providersParam)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
//                    self?.state = .error(error.localizedDescription)
                    self?.providersResult.send(completion: .failure(error))
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                if let providers = result.data?.providers {
                    self?.providersResult.send(providers)
                }else{
                    self?.providersResult.send([])
                }
//                self?.state = .loaded(result.message ?? "")
            }).store(in: &cancellables)
    }

}
