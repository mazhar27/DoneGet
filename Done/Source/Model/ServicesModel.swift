//
//  ServicesModel.swift
//  Done
//
//  Created by Mazhar Hussain on 07/07/2022.
//

import Foundation

struct ServicesDataModel : Codable {
    let main_services : [Main_services]?

    enum CodingKeys: String, CodingKey {

        case main_services = "main_services"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        main_services = try values.decodeIfPresent([Main_services].self, forKey: .main_services)
    }

}

struct Main_services : Codable {
    let service_id : Int?
    let service_title : String?
    let service_icon : String?
    let service_order : String?
    var isSelected = false
    var sub_services : [Sub_services]?

    enum CodingKeys: String, CodingKey {

        case service_id = "service_id"
        case service_title = "service_title"
        case service_icon = "service_icon"
        case service_order = "service_order"
        case sub_services = "sub_services"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        service_id = try values.decodeIfPresent(Int.self, forKey: .service_id)
        service_title = try values.decodeIfPresent(String.self, forKey: .service_title)
        service_icon = try values.decodeIfPresent(String.self, forKey: .service_icon)
        service_order = try values.decodeIfPresent(String.self, forKey: .service_order)
        sub_services = try values.decodeIfPresent([Sub_services].self, forKey: .sub_services)
    }

}
struct Sub_services : Codable {
    let service_id : Int?
    let service_title : String?
    let service_detail : String?
    let service_icon : String?
    var sub_service_title : String?
    let service_order : String?
    let head_service_id : String?
    var categories : [Categories]?
    

    enum CodingKeys: String, CodingKey {

        case service_id = "service_id"
        case service_title = "service_title"
        case service_detail = "service_detail"
        case sub_service_title = "sub_service_title"
        case service_icon = "service_icon"
        case service_order = "service_order"
        case head_service_id = "head_service_id"
        case categories = "categories"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        service_id = try values.decodeIfPresent(Int.self, forKey: .service_id)
        service_title = try values.decodeIfPresent(String.self, forKey: .service_title)
        service_detail = try values.decodeIfPresent(String.self, forKey: .service_detail)
        sub_service_title = try values.decodeIfPresent(String.self, forKey: .sub_service_title)
        service_icon = try values.decodeIfPresent(String.self, forKey: .service_icon)
        service_order = try values.decodeIfPresent(String.self, forKey: .service_order)
        head_service_id = try values.decodeIfPresent(String.self, forKey: .head_service_id)
        categories = try values.decodeIfPresent([Categories].self, forKey: .categories)
    }

}


