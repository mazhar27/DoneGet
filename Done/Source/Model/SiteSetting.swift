//
//  SiteSetting.swift
//  Done
//
//  Created by Mazhar Hussain on 20/10/2022.
//

import Foundation
struct SettingData : Codable {
    let contact_email : String?
    let whatsapp_number : String?
    let customer_address_length : String?
    let additional_count : Int?
    let pending_rating : Int?

    enum CodingKeys: String, CodingKey {

        case contact_email = "contact_email"
        case whatsapp_number = "whatsapp_number"
        case customer_address_length = "customer_address_length"
        case additional_count = "additional_count"
        case pending_rating = "pending_rating"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        contact_email = try values.decodeIfPresent(String.self, forKey: .contact_email)
        whatsapp_number = try values.decodeIfPresent(String.self, forKey: .whatsapp_number)
        customer_address_length = try values.decodeIfPresent(String.self, forKey: .customer_address_length)
        additional_count = try values.decodeIfPresent(Int.self, forKey: .additional_count)
        pending_rating = try values.decodeIfPresent(Int.self, forKey: .pending_rating)
    }

}

