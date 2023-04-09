//
//  PromotionBanners.swift
//  Done
//
//  Created by Mazhar Hussain on 27/10/2022.
//

import Foundation
struct Json4Swift_Base : Codable {
    let response_code : Int?
    let response_message : String?
    let data : [Data]?

    enum CodingKeys: String, CodingKey {

        case response_code = "response_code"
        case response_message = "response_message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        response_code = try values.decodeIfPresent(Int.self, forKey: .response_code)
        response_message = try values.decodeIfPresent(String.self, forKey: .response_message)
        data = try values.decodeIfPresent([Data].self, forKey: .data)
    }

}
struct BanerData : Codable {
    let id : Int?
    let banner_tile : String?
    let image : String?
    let valid_from : String?
    let valid_till : String?
    let discount : String?
    let name : String?
    let type : String?
    let providers : [BannerProviders]?
    let notes : [Notes]?
    let discount_type : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case banner_tile = "banner_tile"
        case image = "image"
        case valid_from = "valid_from"
        case valid_till = "valid_till"
        case discount = "discount"
        case name = "name"
        case type = "type"
        case providers = "providers"
        case notes = "notes"
        case discount_type = "discount_type"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        banner_tile = try values.decodeIfPresent(String.self, forKey: .banner_tile)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        valid_from = try values.decodeIfPresent(String.self, forKey: .valid_from)
        valid_till = try values.decodeIfPresent(String.self, forKey: .valid_till)
        discount = try values.decodeIfPresent(String.self, forKey: .discount)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        providers = try values.decodeIfPresent([BannerProviders].self, forKey: .providers)
        notes = try values.decodeIfPresent([Notes].self, forKey: .notes)
        discount_type = try values.decodeIfPresent(String.self, forKey: .discount_type)
    }

}
struct Notes : Codable {
    let id : Int?
    let note_name : String?
    let promotional_banner_id : Int?
    let note_type : Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case note_name = "note_name"
        case promotional_banner_id = "promotional_banner_id"
        case note_type = "note_type"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        note_name = try values.decodeIfPresent(String.self, forKey: .note_name)
        promotional_banner_id = try values.decodeIfPresent(Int.self, forKey: .promotional_banner_id)
        note_type = try values.decodeIfPresent(Int.self, forKey: .note_type)
    }

}
struct BannerProviders : Codable {
    let id : Int?
    let name : String?
    let services : [BannerServices]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case services = "services"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        services = try values.decodeIfPresent([BannerServices].self, forKey: .services)
    }

}
struct BannerServices : Codable {
    let id : Int?
    let name : String?
    let sub_services : [BannerSub_services]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case sub_services = "sub_services"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        sub_services = try values.decodeIfPresent([BannerSub_services].self, forKey: .sub_services)
    }

}
struct BannerSub_services : Codable {
    let id : Int?
    let name : String?
    let categories : [BannerCategories]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case categories = "categories"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        categories = try values.decodeIfPresent([BannerCategories].self, forKey: .categories)
    }

}
struct BannerCategories : Codable {
    let id : Int?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}


