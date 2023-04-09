//
//  JobDetailsViewModel.swift
//  Done
//
//  Created by Mazhar Hussain on 09/09/2022.
//

import Foundation
import Combine


class JobDetailsViewModel{
    
    private var cancellables = Set<AnyCancellable>()
    let jobDetailsResult = PassthroughSubject<ProviderJobDetailsData, Error>()
    @Published private(set) var state = State.idle
    
    func getJobDetails(jobid: String) {
        ProviderDashBoardRepo.getProviderJobDetails(jobId: jobid)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
//                    self?.state = .error(error.localizedDescription)
                    self?.jobDetailsResult.send(completion: .failure(error))
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                if let statData = result.data{
                    self?.jobDetailsResult.send(statData)
                }
//                self?.state = .loaded(result.message ?? "")
            }).store(in: &cancellables)
    }
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
