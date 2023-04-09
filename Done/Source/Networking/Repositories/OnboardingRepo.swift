//
//  OnboardingRepo.swift
//  Done
//
//  Created by Mazhar Hussain on 6/19/22.
//

import Foundation
import Combine

class OnboardingRepo {
    
    // Login
    static func login(_ number: String, _ pin: String) -> Future<BaseModel<User>,NetworkError> {
    
        let params:[String: Any] = ["phone": Constants.Strings.countryCode+number,
                                    "pin": pin,
                                    "user_type": UserDefaults.userType.rawValue,
                                    "device_token": UserDefaults.deviceToken
        ]
        
        print("Login params: \(params)")
        return NetworkManager.shared.request(url: Router.login(parameters: params))
    }
    
    // Verify Phone number
    static func verifyPhone(_ number: String) -> Future<APIResponse,NetworkError> {
        
        let params:[String: Any] = ["phone": number,
                                    "country_code": Constants.Strings.countryCode,
                                    "user_type": UserDefaults.userType.rawValue]
        return NetworkManager.shared.netWorkRequest(url: Router.register(parameters: params))
    }
    
    // Resend OTP
    static func resendOTP(_ number: String) -> Future<APIResponse,NetworkError> {
        
        let params:[String: Any] = ["phone": Constants.Strings.countryCode+number]
        return NetworkManager.shared.netWorkRequest(url: Router.resendOTP(parameters: params))
    }
    
    // Verify OTP
    static func verifyOTP(_ number: String, _ otp: String,
                          _ isForgotPin: Bool = false) -> Future<BaseModel<Step>,NetworkError> {
        
        var params:[String: Any] = ["phone": Constants.Strings.countryCode+number,
                                    "otp_code": otp]
        if isForgotPin {
            params["forgot_pin"] = true
        }
        
        return NetworkManager.shared.request(url: Router.verifyOTP(parameters: params))
    }
    // Verify OTP to Update Profile
    static func verifyOTPUpdateProfile(_ pin: String, _ otp: String) -> Future<BaseModel<APIResponse>,NetworkError> {
        
        var params:[String: Any] = ["otp_code": otp]
        if pin != ""{
        params = ["otp_code": otp,"pin":pin]
        }
       return NetworkManager.shared.request(url: Router.verifyOTPUpdateProfile(parameters: params))
    }
    
    // Create PIN
    static func createPIN(_ number: String, _ pin: String) -> Future<APIResponse,NetworkError> {
        
        let params:[String: Any] = ["phone": Constants.Strings.countryCode+number,
                                    "pin": pin]
        return NetworkManager.shared.netWorkRequest(url: Router.createPin(parameters: params))
    }
    
    // Basic info
    static func register(_ name: String, _ email: String,
                         number: String, _ pin: String) -> Future<APIResponse,NetworkError> {
        
        let params:[String: Any] = ["full_name": name,
                                    "email": email,
                                    "phone": Constants.Strings.countryCode+number,
                                    "pin": pin]
        return NetworkManager.shared.netWorkRequest(url: Router.basicInfo(parameters: params))
    }
    
    // Logout
    static func logout() -> Future<APIResponse,NetworkError> {
        
        let params:[String: Any] = ["user_type": UserDefaults.userType.rawValue]
        return NetworkManager.shared.netWorkRequest(url: Router.logOut(parameters: params))
    }
    
    // Refresh token
    static func refresh() -> Future<BaseModel<User>,NetworkError> {
        
        return NetworkManager.shared.request(url: Router.refreshToken(parameters: [:]))
    }
}
