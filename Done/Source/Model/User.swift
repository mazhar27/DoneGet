//
//  User.swift
//  Done
//
//  Created by Mazhar Hussain on 6/1/22.
//

import Foundation

// MARK: - User
struct User: Codable {
    let id: Int?
    var name, email, phone, userType: String?
    var profileImage: String?
    var token: Token?

    enum CodingKeys: String, CodingKey {
        case id, name, email, phone
        case userType = "user_type"
        case profileImage = "profile_image"
        case token
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        userType = try values.decodeIfPresent(String.self, forKey: .userType)
        profileImage = try values.decodeIfPresent(String.self, forKey: .profileImage)
        token = try values.decodeIfPresent(Token.self, forKey: .token)
    }
}

// MARK: - Customer address

struct CustomerAddressData : Codable {
    let addresses : [CustomerAddress]?
    let additional_count : Int?

    enum CodingKeys: String, CodingKey {

        case addresses = "addresses"
        case additional_count = "additional_count"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        addresses = try values.decodeIfPresent([CustomerAddress].self, forKey: .addresses)
        additional_count = try values.decodeIfPresent(Int.self, forKey: .additional_count)
    }

}

struct CustomerAddress : Codable {
    var addressId : Int?
    let addressTitle : String?
    let addressName: String?
    let addressDetail: String?
    let longitude : String?
    let latitude : String?
    let street: String?
    let floor: String?
    let providerNote: String?
    var isSelected = false
    
    enum CodingKeys: String, CodingKey {
        case addressId = "address_id"
        case addressTitle = "address_title"
        case longitude
        case latitude
        case addressName = "address_name"
        case addressDetail = "address_description"
        case street
        case floor
        case providerNote = "provider_note"
    }
    
    init(addressId : Int, addressTitle: String, addressName: String, addressDetail: String, longitude: String, latitude: String, street: String,floor: String,providerNote: String) {
        self.addressId = addressId
        self.addressTitle = addressTitle
        self.addressName = addressName
        self.addressDetail = addressDetail
        self.longitude = longitude
        self.latitude = latitude
        self.street = street
        self.floor = floor
        self.providerNote = providerNote
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        addressId = try values.decodeIfPresent(Int.self, forKey: .addressId)
        addressTitle = try values.decodeIfPresent(String.self, forKey: .addressTitle)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
         addressName = try values.decodeIfPresent(String.self, forKey: .addressName)
       addressDetail = try values.decodeIfPresent(String.self, forKey: .addressDetail)
        street = try values.decodeIfPresent(String.self, forKey: .street)
        floor = try values.decodeIfPresent(String.self, forKey: .floor)
        providerNote = try values.decodeIfPresent(String.self, forKey: .providerNote)
    }
    
}


// MARK: - Token
struct Token: Codable {
    let accessToken, refreshToken, tokenType: String?
    let expiresIn: Int?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try values.decodeIfPresent(String.self, forKey: .accessToken)
        refreshToken = try values.decodeIfPresent(String.self, forKey: .refreshToken)
        tokenType = try values.decodeIfPresent(String.self, forKey: .tokenType)
        expiresIn = try values.decodeIfPresent(Int.self, forKey: .expiresIn)
        
    }
}


struct Step: Codable {
    let step: Int?
    
    enum CodingKeys: String, CodingKey {
        case step
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        step = try values.decodeIfPresent(Int.self, forKey: .step)
    }
}
