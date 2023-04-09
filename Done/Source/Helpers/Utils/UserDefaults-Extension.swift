//
//  UserDefaults-Extension.swift
//  Done
//
//  Created by Mazhar Hussain on 6/3/22.
//

import Foundation

public protocol AnyOptional {
    /// Returns `true` if `nil`, otherwise `false`.
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    public var isNil: Bool { self == nil }
}

extension UserDefault where T: ExpressibleByNilLiteral {
    
    /// Creates a new User Defaults property wrapper for the given key.
    /// - Parameters:
    ///   - key: The key to use with the user defaults store.
    init(key: String, _ container: UserDefaults = .standard) {
        self.init(key: key, defaultValue: nil, container: container)
    }
}

@propertyWrapper
struct UserDefault<T: Codable> {
    
    let key: String
    let defaultValue: T
    var container: UserDefaults = .standard
    
    var wrappedValue: T {
        get {
            //return container.object(forKey: key) as? Value ?? defaultValue
            guard let data = container.object(forKey: key) as? Data else {
                // Return defaultValue when no data in UserDefaults
                return defaultValue
            }
            
            // Convert data to the desire data type
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            // Check whether we're dealing with an optional and remove the object if the new value is nil.
            if let optional = newValue as? AnyOptional, optional.isNil {
                container.removeObject(forKey: key)
            } else {
                // Convert newValue to data
                let data = try? JSONEncoder().encode(newValue)
                container.set(data, forKey: key)
            }
        }
    }
    
    var projectedValue: Bool {
        return true
    }
}


extension UserDefaults {
    
    @UserDefault(key: "has_seen_app_introduction", defaultValue: false)
    static var hasSeenAppIntroduction: Bool
    @UserDefault(key: "comigFromNoProvider", defaultValue: false)
    static var comigFromNoProvider: Bool
    
    @UserDefault(key: "has_app_language_changed", defaultValue: false)
    static var hasAppLanguageChanged: Bool
    
    @UserDefault(key: "user_type", defaultValue: UserType.guest)
    static var userType: UserType
    
    @UserDefault(key: "phone_numer", defaultValue: nil)
    static var phoneNumber: String?
    
    @UserDefault(key: "user_pin", defaultValue: nil)
    static var UserPin: String?
    
    @UserDefault(key: "is_Logined", defaultValue: false)
    static var isLogined: Bool
    
    @UserDefault(key: "device_token", defaultValue: "")
    static var deviceToken: String
    
    @UserDefault(key: "addresses", defaultValue: nil)
    static var addresses: [CustomerAddress]?
    
    @UserDefault(key: "cartData", defaultValue: nil)
    static var cartData: [Services]?
    
    @UserDefault(key: "addressesGuest", defaultValue: nil)
    static var addressesGuest: [CustomerAddress]?
    
    @UserDefault(key: "couponCodes", defaultValue: nil)
    static var couponCodes: [String]?
    
    @UserDefault(key: "login_user_info", defaultValue: nil)
    static var LoginUser: User?
    
}
