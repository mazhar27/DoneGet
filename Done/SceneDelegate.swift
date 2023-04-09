//
//  SceneDelegate.swift
//  Done
//
//  Created by macbook on 5/30/22.
//

import UIKit
import Foundation
import Localize_Swift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        AppDelegate.shared.window = window
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        
        getRootController()
        //        getRootControllerTesting()
    }
    @objc func languageChanged() -> () {
        getRootController()
    }
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    //MARK: - Set root view controller
    private func getRootController(){
        

        if UserDefaults.hasSeenAppIntroduction {
            if UserDefaults.isLogined {
                if UserDefaults.userType == .provider{
                    let mainStoryboard = UIStoryboard(name: Storyboards.provider, bundle: nil)
                    guard let initialNavigator = mainStoryboard.instantiateViewController(withIdentifier:
                                                                                                    "ProviderNav") as? UINavigationController else {
                        return
                    }
                    setRootController(viewController: initialNavigator)
                    
                }else{
                let mainStoryboard = UIStoryboard(name: Storyboards.main, bundle: nil)
                guard let initialNavigator = mainStoryboard.instantiateViewController(withIdentifier:
                                                                                                "dashboardNavigator") as? UINavigationController else {
                    return
                }
                setRootController(viewController: initialNavigator)
                }
            }else {
                let onBoardingStoryboard = UIStoryboard(name: Storyboards.onBoarding, bundle: nil)
                guard let initialNavigator = onBoardingStoryboard.instantiateViewController(withIdentifier:
                                                                                                "RoleSelectionNavigator") as? UINavigationController else {
                    return
                }
                setRootController(viewController: initialNavigator)
            }
            
        } else {
            let onBoardingStoryboard = UIStoryboard(name: Storyboards.onBoarding, bundle: nil)
            guard let initialNavigator = onBoardingStoryboard.instantiateViewController(withIdentifier:
                                                                                            "initialNavigator") as? UINavigationController else {
                return
            }
            setRootController(viewController: initialNavigator)
        }
    }
    
    private func getRootControllerTesting(){
        let onBoardingStoryboard = UIStoryboard(name: Storyboards.onBoarding, bundle: nil)
        guard let initialNavigator = onBoardingStoryboard.instantiateViewController(withIdentifier:
                            "SignUpVC") as? UIViewController else {
            return
        }
        setRootControllerTesting(viewController: initialNavigator)
        
    }
    
    func setRootController(viewController: UINavigationController) {
        for view in (window?.subviews)!{
            view.removeFromSuperview()
        }
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
    }
    func setRootControllerTesting(viewController: UIViewController) {
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
    }
    
}

