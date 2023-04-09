//
//  NotificationsModel.swift
//  Done
//
//  Created by Mazhar Hussain on 31/08/2022.
//

import Foundation

struct NotificationsModel : Codable {
    var data : [NotificationsData]?
    let links : NotificationsLinks?
    let meta : Meta?
    let status : Int?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case data = "data"
        case links = "links"
        case meta = "meta"
        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([NotificationsData].self, forKey: .data)
        links = try values.decodeIfPresent(NotificationsLinks.self, forKey: .links)
        meta = try values.decodeIfPresent(Meta.self, forKey: .meta)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}
struct NotificationDataGrouped {
    var date = Date()
    var notificationData = [NotificationsData]()
}
struct NotificationsData : Codable {
    let notification_title : String?
    let notification_detail : String?
    let created_at : String?
    let is_whatsapp : Int?
    let time : String?
    var date = Date()

    enum CodingKeys: String, CodingKey {

        case notification_title = "notification_title"
        case notification_detail = "notification_detail"
        case created_at = "created_at"
        case is_whatsapp = "is_whatsapp"
        case time = "time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        notification_title = try values.decodeIfPresent(String.self, forKey: .notification_title)
        notification_detail = try values.decodeIfPresent(String.self, forKey: .notification_detail)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        is_whatsapp = try values.decodeIfPresent(Int.self, forKey: .is_whatsapp)
        time = try values.decodeIfPresent(String.self, forKey: .time)
    }

}
struct Meta : Codable {
    let current_page : Int?
    let from : Int?
    let last_page : Int?
    let path : String?
    let per_page : Int?
    let to : Int?
    let total : Int?

    enum CodingKeys: String, CodingKey {

        case current_page = "current_page"
        case from = "from"
        case last_page = "last_page"
        case path = "path"
        case per_page = "per_page"
        case to = "to"
        case total = "total"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        current_page = try values.decodeIfPresent(Int.self, forKey: .current_page)
        from = try values.decodeIfPresent(Int.self, forKey: .from)
        last_page = try values.decodeIfPresent(Int.self, forKey: .last_page)
        path = try values.decodeIfPresent(String.self, forKey: .path)
        per_page = try values.decodeIfPresent(Int.self, forKey: .per_page)
        to = try values.decodeIfPresent(Int.self, forKey: .to)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
    }

}
struct NotificationsLinks : Codable {
    let first : String?
    let last : String?
    let prev : String?
    let next : String?

    enum CodingKeys: String, CodingKey {

        case first = "first"
        case last = "last"
        case prev = "prev"
        case next = "next"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        first = try values.decodeIfPresent(String.self, forKey: .first)
        last = try values.decodeIfPresent(String.self, forKey: .last)
        prev = try values.decodeIfPresent(String.self, forKey: .prev)
        next = try values.decodeIfPresent(String.self, forKey: .next)
    }

}


