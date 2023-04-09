//
//  AppDelegate.swift
//  Done
//
//  Created by macbook on 5/30/22.
//

import UIKit
import GoogleMaps
import GooglePlaces
import IQKeyboardManager
import SVProgressHUD
import Firebase
import FirebaseMessaging
import Localize_Swift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    static var shared: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared().isEnabled = true
        configureGoogleMaps()
        setSVProgressHUD()
        configurePushNotifications(application)
        NetworkManager.shared.startMonitoring()
      
        if Localize.currentLanguage() == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            
        }else{
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        UserDefaults.comigFromNoProvider = false
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
   
    private func configureGoogleMaps() {
        
        GMSPlacesClient.provideAPIKey(Constants.Keys.GoogleMapsPlacesKey)
        GMSServices.provideAPIKey(Constants.Keys.GoogleMapsPlacesKey)
    }
    
    private func setSVProgressHUD() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setDefaultAnimationType(.native)
    }
    
    private func configurePushNotifications(_ application: UIApplication) {
        self.registerNotificationSettings(application: application)
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
    }
    
    private func registerNotificationSettings(application: UIApplication) {
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        //UNUserNotificationCenter.current().delegate = self // For iOS 10 display notification (sent via APNS) for when app in foreground
        application.registerForRemoteNotifications()
    }
}


extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken {
            UserDefaults.deviceToken = token
        }
    }
}
