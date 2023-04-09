//
//  JobRejectionViewModel.swift
//  Done
//
//  Created by Mazhar Hussain on 13/09/2022.
//

import Foundation
import Combine
import Localize_Swift

class JobRejectionViewModel{
    
    var reasonsArray = ["The location is far away".localized(),"I am not available".localized(),"Price is not upto requirement".localized(),"I am not satisfied with the price".localized(),"Other".localized()]
    private var cancellables = Set<AnyCancellable>()
    @Published private(set) var state = State.idle
    
    func setJobStatus(serviceID: String, reason: String,status: String) {
        self.state = .loading
        ProviderDashBoardRepo.changeJobStatus(orderServiceID: serviceID, rejectionReason: reason, status: status)
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
