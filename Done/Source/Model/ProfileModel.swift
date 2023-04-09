//
//  ProfileModel.swift
//  Done
//
//  Created by Mazhar Hussain on 01/08/2022.
//

import Foundation

struct ProfileData : Codable {
    let name : String?
    let email : String?
    let verify_email : Int?
    let phone : String?
    let image : String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case email = "email"
        case verify_email = "verify_email"
        case phone = "phone"
        case image = "image"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        verify_email = try values.decodeIfPresent(Int.self, forKey: .verify_email)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        image = try values.decodeIfPresent(String.self, forKey: .image)
    }

}

