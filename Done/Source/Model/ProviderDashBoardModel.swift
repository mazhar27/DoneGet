//
//  ProviderDashBoardModel.swift
//  Done
//
//  Created by Mazhar Hussain on 05/09/2022.
//

import Foundation

struct ProviderDashboardData : Codable {
    let company_name : String?
    let logo_image : String?
    let wallet_balance : Double?
    let notification_count : Int?
    let stats : [Stats]?

    enum CodingKeys: String, CodingKey {

        case company_name = "company_name"
        case logo_image = "logo_image"
        case wallet_balance = "wallet_balance"
        case notification_count = "notification_count"
        case stats = "stats"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        company_name = try values.decodeIfPresent(String.self, forKey: .company_name)
        logo_image = try values.decodeIfPresent(String.self, forKey: .logo_image)
        wallet_balance = try values.decodeIfPresent(Double.self, forKey: .wallet_balance)
        notification_count = try values.decodeIfPresent(Int.self, forKey: .notification_count)
        stats = try values.decodeIfPresent([Stats].self, forKey: .stats)
    }

}
struct Stats : Codable {
    let title : String?
    let stat : Int?
    let icon : String?
    let job_type : String?

    enum CodingKeys: String, CodingKey {

        case title = "title"
        case stat = "stat"
        case icon = "icon"
        case job_type = "job_type"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        stat = try values.decodeIfPresent(Int.self, forKey: .stat)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        job_type = try values.decodeIfPresent(String.self, forKey: .job_type)
    }

}


