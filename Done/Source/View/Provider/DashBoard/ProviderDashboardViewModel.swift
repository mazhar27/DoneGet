//
//  ProviderDashboardViewModel.swift
//  Done
//
//  Created by Mazhar Hussain on 05/09/2022.
//

import Foundation
import Combine

class ProviderDashboardViewModel{
    
    private var cancellables = Set<AnyCancellable>()
    let providerStatsResult = PassthroughSubject<ProviderDashboardData, Error>()
    let settingsResult = PassthroughSubject<SettingData, Error>()


 func getAttributedTitle(title: String) -> NSMutableAttributedString {
    
    let attributedString = NSMutableAttributedString(string: "Hello, \(title) !")
    attributedString.addAttributes([NSAttributedString.Key.font: UIFont.Poppins(.semibold, size: 16),
                                    NSAttributedString.Key.foregroundColor: UIColor.labelTitleColor],
                                   range: NSMakeRange(0, 6))
    return attributedString
}
    func getSiteSettings() {
        DashboardRepo.getSiteSetting()
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
//                    self?.state = .error(error.localizedDescription)
                   
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                if let setting = result.data {
                    self?.settingsResult.send(setting)
                }
//                self?.state = .loaded(result.message ?? "")
            }).store(in: &cancellables)
    }
    
    func getAllProviderStats() {
        ProviderDashBoardRepo.getProviderDashStats()
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
//                    self?.state = .error(error.localizedDescription)
                    self?.providerStatsResult.send(completion: .failure(error))
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                if let statData = result.data{
                    self?.providerStatsResult.send(statData)
                }
//                self?.state = .loaded(result.message ?? "")
            }).store(in: &cancellables)
    }
}
