//
//  DashboardViewModel.swift
//  Done
//
//  Created by Mazhar Hussain on 29/06/2022.
//

import Foundation
import Combine

class DashboardViewModel{
    
    private var cancellables = Set<AnyCancellable>()
    let customerAddressesResult = CurrentValueSubject<[CustomerAddress], Error>([])
    let bannersAndPromotionsResults = PassthroughSubject<[BanerData], Error>()
    let settingsResult = PassthroughSubject<SettingData, Error>()
    @Published private(set) var state = State.idle
    @Published private(set) var message = ""
    
    
    func getAddresses() {
        DashboardRepo.getCustomerAddresses()
            
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
//                    self?.state = .error(error.localizedDescription)
                    self?.customerAddressesResult.send(completion: .failure(error))
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                if let userAddresses = result.data {
                    self?.customerAddressesResult.send(userAddresses)
                }
//                self?.state = .loaded(result.message ?? "")
            }).store(in: &cancellables)
    }
    func getBannersAndPromotions() {
        DashboardRepo.getBannerAndPromotions()
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.bannersAndPromotionsResults.send(completion: .failure(error))
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                if let bannersAndPromotions = result.data {
                    self?.bannersAndPromotionsResults.send(bannersAndPromotions)
                }
            }).store(in: &cancellables)
    }
    func getSiteSettings() {
        DashboardRepo.getSiteSetting()
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
//                    self?.state = .error(error.localizedDescription)
                    self?.customerAddressesResult.send(completion: .failure(error))
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
    func deleteAddress(addressID: String) {
        self.state = .loading
        DashboardRepo.deleteCustomerAddresses(addressID: addressID)
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
    func deleteCustomerAccount(pin: String) {
        self.state = .loading
        DashboardRepo.deleteCustomerAccountNew(param: ["pin":pin])
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
                    if result.code == 200{
                    self?.message = result.message ?? ""
                    }else{
                        self?.state = .error(result.message ?? "")
                    }
                }
            }).store(in: &cancellables)
    }
    
    func checkCartEmpty()-> Bool{
        if UserDefaults.cartData?.count != 0 && UserDefaults.cartData != nil{
            let location = SessionModel.shared.location
            if location.longitude != UserDefaults.cartData?[0].address_longitude{
                return false
            }else{
                return true
            }
        }else{
            return true
        }
    }
}
