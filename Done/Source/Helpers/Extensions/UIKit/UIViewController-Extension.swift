//
//  UIViewController-Extension.swift
//  Done
//
//  Created by Mazhar Hussain on 5/30/22.
//

import UIKit

extension UIViewController {
    // getting top view controller currently visible
    func topViewController() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topViewController() ?? tab
        }
        
        return self
    }
    
    func setRootViewController(storyboard: String, identifier: String) {
       
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        guard let navigator = storyboard.instantiateViewController(withIdentifier:
                                                                    identifier) as? UINavigationController else {
            return
        }
//        autoreleasepool {
            self.sceneDelegate?.setRootController(viewController: navigator)
        print("nothing")
//        }
       
    }
    
}

extension UIViewController {
        var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var sceneDelegate: SceneDelegate? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let delegate = windowScene.delegate as? SceneDelegate else { return nil }
         return delegate
    }
}
