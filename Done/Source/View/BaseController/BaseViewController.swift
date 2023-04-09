//
//  BaseViewController.swift
//  Done
//
//  Created by Mazhar Hussain on 6/9/22.
//

import UIKit
import SideMenu
import Localize_Swift
//import NotificationBannerSwift
import SwiftMessages

class BaseViewController: UIViewController {
    
   
    var callBackClousure:((_ isDismesed: Bool)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        styleNavigationBar()
        if Localize.currentLanguage() == "ar" {
            self.navigationController?.navigationBar.semanticContentAttribute = .forceRightToLeft
        }else{
            self.navigationController?.navigationBar.semanticContentAttribute = .forceLeftToRight
        }
       // self.loopThroughSubViewAndAlignTextfieldText(subviews: self.view.subviews)
        //self.loopThroughSubViewAndAlignLabelText(subviews: self.view.subviews)
        
        setNavigtionBarItems()
//        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarHidden()
   }
    func setBadge(){
        let barButtonItem = self.navigationItem.rightBarButtonItem!
        let buttonItemView = barButtonItem.value(forKey: "view") as? UIView
        let buttonItemSize = buttonItemView?.frame
        let dotView = UIView()
        var dotSize = 8
        if UserDefaults.cartData?.count != 0 && UserDefaults.cartData != nil{
          
          
            dotView.backgroundColor = .red //Just change colors
            dotView.layer.cornerRadius = CGFloat(dotSize/2)
            dotView.layer.frame = CGRect(x: Int(buttonItemSize?.width ?? 0) , y:
                                            0, width: dotSize, height: dotSize)
            buttonItemView?.addSubview(dotView)
        }else{
           
            dotView.removeFromSuperview()
            dotView.backgroundColor = .clear
            dotSize = 0
            addRightBarButtonItems()
        }
    }
    
    func setNavigationBarHidden(_ hide: Bool = false) {
//        navigationController?.setNavigationBarHidden(hide, animated: false)
        if self is ProviderDashboardVC || self is TimeSlotVC || self is ProviderProfileVC || self is LoginVC || self is SideMenuViewController || self is VerifyOTPVC || self is ForgotPinVC || self is SignUpVC || self is VerifyPhoneVC || self is ProfileVC{
            navigationController?.setNavigationBarHidden(true, animated: false)
        }else{
            navigationController?.setNavigationBarHidden(false, animated: false)
        }

    }
   
    func openHelpSupport(){
        let phoneNumber = adminPhone
        let urlString = "https://api.whatsapp.com/send?phone=\(phoneNumber)&text=\(String(describing: ""))"
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = URL(string: encodedString!)

        if UIApplication.shared.canOpenURL(url!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(url!)
            }
        }
        else {
            // Whatsapp is not installed
        }
    }
    
    //MARK: - Set navigation bar
    private func styleNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationBarTintColor
       self.navigationController?.navigationBar.shadowImage = UIImage()
}
    fileprivate func setNavigtionBarItems() {
     if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = UIColor.navigationBarTintColor

            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            //navigationController?.navigationBar.compactAppearance = appearance
            
        } else {
            // Fallback on earlier versions
            navigationController?.navigationBar.barTintColor = UIColor.navigationBarTintColor

        }
    }
    
    //MARK: - Custom alert
//    func showAlert(_ title: String = "Done", _ message: String,
//                   _ style: Theme = .danger, _ onController: Bool = true) {
//        let banner = NotificationBanner(title: title, subtitle: message, style: style)
//        banner.show(queuePosition: .back, bannerPosition: .top, queue: .default, on: onController ? self : nil)
//    }
    func showAlert(_ title: String = "Done".localized(), _ message: String,
                   _ style: Theme = .error) {
        let messageView = MessageView.viewFromNib(layout: .messageView)
        messageView.configureContent(title: "", body: message)
        var backGroundColor = "e55042"
        if style == .error {
            backGroundColor = "e55042"
        } else if style == .info{
            backGroundColor = "e55042"
        }else if style == .warning{
            backGroundColor = "e55042"
        }else if style == .success{
            backGroundColor = "127DC6"
        }
        
        messageView.configureTheme(backgroundColor: UIColor(hexString: backGroundColor),
                                   foregroundColor: .white, iconImage: nil, iconText: nil)
    
        messageView.button?.isHidden = true
        SwiftMessages.show(view: messageView)
    
    }
    
     func getMainStoryboard() -> UIStoryboard {
       UIStoryboard(name: Storyboards.main, bundle: nil)
    }
    func getProviderStoryboard() -> UIStoryboard {
      UIStoryboard(name: Storyboards.provider, bundle: nil)
   }
    func getOnboardingStoryboard() -> UIStoryboard {
      UIStoryboard(name: Storyboards.onBoarding, bundle: nil)
   }
    
    
}

//MARK: - Add UIBar Button Items
extension  BaseViewController {
    
    func addUnderLineTitle(title: String, enableTap: Bool = false) {
        let view = UIView(frame: CGRect(x: 0, y:0, width: self.view.frame.width - 80, height: 50))
        let label = UILabel.init(frame: CGRect(x: 10, y:8, width: view.frame.width, height: 30))
        label.textColor = UIColor.labelTitleColor
        label.font = UIFont.Poppins(.regular, size: 16)
        label.text = title
        if Localize.currentLanguage() == "ar" {
            label.textAlignment = .left
        }else{
            label.textAlignment = .right
        }
        let line = UILabel.init(frame: CGRect(x: 4, y:label.frame.maxY, width: view.frame.width, height: 1))
        line.backgroundColor = UIColor(hexString: "ACACAC")
        
        if enableTap {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigationTitleTapped))
            view.addGestureRecognizer(tapGesture)
        }
        view.addSubview(label)
        view.addSubview(line)
        self.navigationItem.titleView = view
   }
   
   func addMenuIcon(title: String = "") {
       let sideMenuButton = UIButton(type: .custom)
       sideMenuButton.addTarget(self, action: #selector(didTappedSidMenu), for: .touchUpInside)
       sideMenuButton.setImage(UIImage(named: "menuIcon"), for: .normal)
       sideMenuButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
       if title.isEmpty {
           let sideMenuBarButtonItem  = UIBarButtonItem(customView: sideMenuButton)
//           if Localize.currentLanguage() == "ar" {
//               self.navigationItem.rightBarButtonItems = [sideMenuBarButtonItem]
//
//           }else{
               self.navigationItem.leftBarButtonItems = [sideMenuBarButtonItem]
           //}
       }else {
           let label = UILabel()
           label.textColor = .blueThemeColor
           label.font = UIFont.Poppins(.semibold, size: 20)
           label.attributedText = getAttributedTitle(title: title)
           let sideMenuBarButtonTitle = UIBarButtonItem(customView: label)
           let sideMenuBarButtonItem  = UIBarButtonItem(customView: sideMenuButton)
//           if Localize.currentLanguage() == "ar" {
//               self.navigationItem.rightBarButtonItems = [sideMenuBarButtonItem,sideMenuBarButtonTitle]
//               label.textAlignment = .right
//           }else{
               self.navigationItem.leftBarButtonItems = [sideMenuBarButtonItem,sideMenuBarButtonTitle]
               label.textAlignment = .left
           //}
       }
       
   }
   
    func addLeftBarButtonItem(name: String = "backIcon") {
        let button = createButton(imageNamed: name)
        button.addTarget(self, action: #selector(btnBackAction), for: .touchUpInside)
        let backButtonItem  = UIBarButtonItem(customView: button)
        
        if Localize.currentLanguage() == "ar" {
            button.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }else{
            button.transform = .identity
        }
        self.navigationItem.leftBarButtonItem = backButtonItem
        
    }
   
   func addRightBarButtonItems(disabledNotif: Bool = false) {
      
       let cartbutton = createButton(imageNamed: "cartIcon")
      
      
       cartbutton.addTarget(self, action: #selector(btnCartAction), for: .touchUpInside)
       let cartbuttonButtonItem  = UIBarButtonItem(customView: cartbutton)
      
       
       if !disabledNotif{
           let button = createButton(imageNamed: "notificationIcon")
           button.addTarget(self, action: #selector(btnNotificationAction), for: .touchUpInside)
           let notificationButtonItem  = UIBarButtonItem(customView: button)
//           if Localize.currentLanguage() == "ar" {
//               self.navigationItem.leftBarButtonItems = [cartbuttonButtonItem, notificationButtonItem]
//
//           }else{
               self.navigationItem.rightBarButtonItems = [cartbuttonButtonItem, notificationButtonItem]
           //}

       } else {
//           if Localize.currentLanguage() == "ar" {
//               self.navigationItem.leftBarButtonItems = [cartbuttonButtonItem]
//
//           }else{
               self.navigationItem.rightBarButtonItems = [cartbuttonButtonItem]
         
         
           //}
       }
   }
   
   func addRightBarButtonItem(imageName: String) {
       
       let rightbutton = createButton(imageNamed: imageName)
       rightbutton.addTarget(self, action: #selector(rightBarButtonAction), for: .touchUpInside)
       let rightButtonItem  = UIBarButtonItem(customView: rightbutton)
       self.navigationItem.rightBarButtonItems = [rightButtonItem]
       
   }
   
   private func createButton(imageNamed: String) -> UIButton {
       let button = UIButton(type: .custom)
       button.setImage(UIImage(named: imageNamed), for: .normal)
       button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
       return button
   }
   
   
   private func getAttributedTitle(title: String) -> NSMutableAttributedString {
       let helloString = "Hello".localized()
       let attributedString = NSMutableAttributedString(string: "\(helloString), \(title)")
       attributedString.addAttributes([NSAttributedString.Key.font: UIFont.Poppins(.regular, size: 16),
                                       NSAttributedString.Key.foregroundColor: UIColor.labelTitleColor],
                                      range: NSMakeRange(0, 6))
       return attributedString
   }
    
    @objc func btnBackAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func btnNotificationAction() {
        
    }
    
    @objc func rightBarButtonAction() {
        print("right bar button tapped")
    }
    
    @objc func navigationTitleTapped() {
        print("navigationTitleTapped")
    }
    
    @objc func btnCartAction() {
        
    }
}


//MARK: - Side menu settings
extension  BaseViewController {

    private func showSideMenu() {
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view, forMenu: .left)
      if Localize.isRTL {
            SideMenuManager.default.rightMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
            if let controller = SideMenuManager.default.rightMenuNavigationController?.viewControllers[0] as? SideMenuViewController{
                controller.dataPassClousure = {[weak self] (isDismesed) -> Void in
                   self?.callBackClousure?(true)
               }
            }
          SideMenuManager.default.rightMenuNavigationController?.settings = makeSettings()
          present(SideMenuManager.default.rightMenuNavigationController!, animated: true, completion: nil)

        } else {
            SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
            if let controller = SideMenuManager.default.leftMenuNavigationController?.viewControllers[0] as? SideMenuViewController{
                controller.dataPassClousure = {[weak self] (isDismesed) -> Void in
                   self?.callBackClousure?(true)
               }
            }
            SideMenuManager.default.leftMenuNavigationController?.settings = makeSettings()
            present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
        }
       
    }

    private func selectedPresentationStyle() -> SideMenuPresentationStyle {
        let modes: [SideMenuPresentationStyle] = [.menuSlideIn, .viewSlideOut, .viewSlideOutMenuIn, .menuDissolveIn]
        return modes[0]
    }

    private func makeSettings() -> SideMenuSettings {
        let presentationStyle = selectedPresentationStyle()
        presentationStyle.menuStartAlpha = 0.0
        presentationStyle.presentingEndAlpha = 0.7
    
        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.menuWidth = (view.frame.width-90)
        let styles:[UIBlurEffect.Style?] = [nil, .dark, .light, .extraLight]
        settings.blurEffectStyle = styles[1]
        settings.statusBarEndAlpha = 0
        return settings
    }
    
    //MARK: - Target actions
    @objc func didTappedSidMenu() {
        showSideMenu()
    }
}

extension UIViewController {

//Align Textfield Text

    func loopThroughSubViewAndAlignTextfieldText(subviews: [UIView]) {
        if Localize.currentLanguage() == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            
        }else{
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        if subviews.count > 0 {
            for subView in subviews {
                if subView is UITextField && subView.tag <= 0{
                    let textField = subView as! UITextField
                    textField.textAlignment = Localize.currentLanguage() == "ar" ? .right: .left
                } else if subView is UITextView && subView.tag <= 0{
                    if subView is OTPCodeTextField {
                        
                    }else{
                        let textView = subView as! UITextView
                        textView.textAlignment = Localize.currentLanguage() == "ar" ? .right: .left
                    }
                }else if subView is UIButton && subView.tag <= 0 && Localize.currentLanguage() == "ar"{
                    print("button found")
                    let button = subView as! UIButton
                    
                    if button.currentImage != nil && button.currentImage!.description.contains("backIcon") {
                        button.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                    }
                }
                
                loopThroughSubViewAndAlignTextfieldText(subviews: subView.subviews)
            }
        }
    }


//Align Label Text
    func loopThroughSubViewAndAlignLabelText(subviews: [UIView]) {
        if subviews.count > 0 {
            for subView in subviews {
                if subView is UILabel && subView.tag <= 0 {
                    let label = subView as! UILabel
                    if label.textAlignment != .center {
                        label.textAlignment = Localize.currentLanguage() == "ar" ? .right : .left
                    }
                }
                loopThroughSubViewAndAlignLabelText(subviews: subView.subviews)
            }
        }
    }
}
