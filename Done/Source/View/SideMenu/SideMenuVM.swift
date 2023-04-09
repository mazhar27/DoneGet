//
//  SideMenuVM.swift
//  Done
//
//  Created by Mazhar Hussain on 13/06/2022.
//

import Foundation
import Localize_Swift
import Combine


class SideMenuViewModel {
    
    var items = [SideMenuItem]()
    @Published private(set) var state = State.idle
    @Published private(set) var user : User? = nil
    private var cancellables = Set<AnyCancellable>()
    
    func getItems() {
        
        items = [SideMenuItem(title: "My Orders".localized(), ImageName: "ordersIcon"),SideMenuItem(title: "My Cart".localized(), ImageName: "myCartIcon"),SideMenuItem(title: "Additional Invoice".localized(), ImageName: "invoiceIcon"),SideMenuItem(title: "Wallet".localized(), ImageName: "walletIcon"),SideMenuItem(title: "Help & Support".localized(), ImageName: "helpIcon"),SideMenuItem(title: "Delete Account".localized(), ImageName: "deleteAccountIcon"),SideMenuItem(title: "Logout".localized(), ImageName: "logoutIocn")]
        
    }
    
    func logout() {
        self.state = .loading
        OnboardingRepo.logout()
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.state = .error(error.errorDescription ?? "")
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                print("response : \(result)")
                self?.state = .loaded(result.message ?? "")
                
            }).store(in: &cancellables)
    }
    
}

