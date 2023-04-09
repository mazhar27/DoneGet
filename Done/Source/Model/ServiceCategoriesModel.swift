//
//  ServiceCategoriesModel.swift
//  Done
//
//  Created by Mazhar Hussain on 07/07/2022.
//

import Foundation


struct ServiceCategoriesDataModel : Codable {
    let categories : [Categories]?

    enum CodingKeys: String, CodingKey {

        case categories = "categories"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categories = try values.decodeIfPresent([Categories].self, forKey: .categories)
    }

}

struct Categories : Codable {
    let category_id : Int?
    let category_title : String?
    let category_summary : String?
    let category_detail : String?
    let category_order : String?
    let service : Service?
    enum CodingKeys: String, CodingKey {

        case category_id = "category_id"
        case category_title = "category_title"
        case category_summary = "category_summary"
        case category_detail = "category_detail"
        case category_order = "category_order"
        case service = "service"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        category_id = try values.decodeIfPresent(Int.self, forKey: .category_id)
        category_title = try values.decodeIfPresent(String.self, forKey: .category_title)
        category_summary = try values.decodeIfPresent(String.self, forKey: .category_summary)
        category_detail = try values.decodeIfPresent(String.self, forKey: .category_detail)
        category_order = try values.decodeIfPresent(String.self, forKey: .category_order)
        service = try values.decodeIfPresent(Service.self, forKey: .service)
    }

}



