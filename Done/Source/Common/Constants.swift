//
//  Constants.swift
//  Done
//
//  Created by Mazhar Hussain on 6/7/22.
//

import Foundation

var adminPhone = ""
var additionalInvoiceCount = 0


struct Constants {
  
    
    struct Keys {
        static let GoogleMapsPlacesKey = ""
        static let GoogleMapsGeocodeKey = ""
    }
    
    struct API {
        

        static let baseURL = "" // live
        static let imageBaseURL = ""
    } 
    
    struct Strings {
        static let countryCode = "+966"
        static let RequestError = "Sorry, Some wrong, please try again."
        static let networkError = "No internet found!, please try again later."
        static let token = "access_token"
       
        static let refreshToken = "refresh_token"
    }
    
    struct Version {
        static let shortVersion  = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        static let bundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    }
}

