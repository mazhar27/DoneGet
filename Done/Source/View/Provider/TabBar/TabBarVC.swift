//
//  TabBarVC.swift
//  Done
//
//  Created by Mazhar Hussain on 05/09/2022.
//

import UIKit
import Localize_Swift

class TabBarVC: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Localize.currentLanguage() == "ar"{
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else{
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        initialSetup()
        addingController()
    }
    func addingController(){
        var controllers = self.viewControllers
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let VC = storyboard.instantiateViewController(WalletVC.self) else {
            return
        }
        
        let walletVC = VC
        walletVC.title = "Wallet".localized()
        walletVC.tabBarItem.image = UIImage.init(named: "walletDashIcon")
        controllers?.insert(walletVC, at: 2)
        guard let vc = storyboard.instantiateViewController(NotificationsVC.self) else {
            return
        }
        let notifVC = vc
        notifVC.title = "Notifications".localized()
        notifVC.tabBarItem.image = UIImage.init(named: "notificationDashIcon")
        controllers?.insert(notifVC, at: 4)
        self.viewControllers = controllers
        if let items = self.tabBar.items {
            items[0].title = "Dashboard".localized()
            items[1].title = "Time Slots".localized()
            items[3].title = "Profile".localized()
        }
    }
    
    private func initialSetup(){
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.Poppins(.regular, size: 11)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.Poppins(.regular, size: 11)], for: .selected)
        self.tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.tabBar.layer.shadowOpacity = 0.5
        self.tabBar.layer.shadowOffset = CGSize.zero
        self.tabBar.layer.shadowRadius = 5
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBar.layer.borderWidth = 0
        self.tabBar.clipsToBounds = false
        self.tabBar.backgroundColor = UIColor.white
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
    }
    
}
