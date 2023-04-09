//
//  ProvidersListModel.swift
//  Done
//
//  Created by Mazhar Hussain on 20/07/2022.
//

import Foundation
struct ProvidersListModel : Codable {
    let status_code : Int?
    let message : String?
    let data : ProvidersListData?

    enum CodingKeys: String, CodingKey {

        case status_code = "status_code"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(ProvidersListData.self, forKey: .data)
    }

}
struct ProvidersListData : Codable {
    let providers : [Providers]?

    enum CodingKeys: String, CodingKey {

        case providers = "providers"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        providers = try values.decodeIfPresent([Providers].self, forKey: .providers)
    }

}
struct Provider_address : Codable {
    let user_id : String?
    let latitude : String?
    let longitude : String?
    let address_title : String?

    enum CodingKeys: String, CodingKey {

        case user_id = "user_id"
        case latitude = "latitude"
        case longitude = "longitude"
        case address_title = "address_title"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        address_title = try values.decodeIfPresent(String.self, forKey: .address_title)
    }

}
struct Provider_detail : Codable {
    let user_id : Int?
    let name : String?
    let email : String?
    let phone : String?
    let crNumber : String?
    let description : String?
    let logo_image : String?
    let working_radius : Int?

    enum CodingKeys: String, CodingKey {

        case user_id = "user_id"
        case name = "name"
        case email = "email"
        case phone = "phone"
        case crNumber = "crNumber"
        case description = "description"
        case logo_image = "logo_image"
        case working_radius = "working_radius"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        crNumber = try values.decodeIfPresent(String.self, forKey: .crNumber)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        logo_image = try values.decodeIfPresent(String.self, forKey: .logo_image)
        working_radius = try values.decodeIfPresent(Int.self, forKey: .working_radius)
    }

}
struct Providers : Codable {
    let service_type : Int?
    let is_home : Int?
    let is_pick : Int?
    let provider_service_id : Int?
    let service_id : String?
    let provider_id : String?
    let rating : String?
    let service_price : String?
    let provider_detail : Provider_detail?
    let provider_address : Provider_address?
    let user : ProviderUser?

    enum CodingKeys: String, CodingKey {

        case service_type = "service_type"
        case is_home = "is_home"
        case is_pick = "is_pick"
        case provider_service_id = "provider_service_id"
        case service_id = "service_id"
        case provider_id = "provider_id"
        case rating = "rating"
        case service_price = "service_price"
        case provider_detail = "provider_detail"
        case provider_address = "provider_address"
        case user = "user"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        service_type = try values.decodeIfPresent(Int.self, forKey: .service_type)
        is_home = try values.decodeIfPresent(Int.self, forKey: .is_home)
        is_pick = try values.decodeIfPresent(Int.self, forKey: .is_pick)
        provider_service_id = try values.decodeIfPresent(Int.self, forKey: .provider_service_id)
        service_id = try values.decodeIfPresent(String.self, forKey: .service_id)
        provider_id = try values.decodeIfPresent(String.self, forKey: .provider_id)
        rating = try values.decodeIfPresent(String.self, forKey: .rating)
        service_price = try values.decodeIfPresent(String?.self, forKey: .service_price) ?? "0"
        provider_detail = try values.decodeIfPresent(Provider_detail.self, forKey: .provider_detail)
        provider_address = try values.decodeIfPresent(Provider_address.self, forKey: .provider_address)
        user = try values.decodeIfPresent(ProviderUser.self, forKey: .user)
    }

}
struct ProviderUser : Codable {
    let id : Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
    }

}
struct ProvidersListParameterModel{
    var date = ""
    var sort_price_dsc = ""
    var sort_price_asc = ""
    var sort_rating = ""
    var latitude = ""
    var service_type = ""
    var category_id = ""
    var options = [Int]()
    var time = ""
    var longitude = ""
}


