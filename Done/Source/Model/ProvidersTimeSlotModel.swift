//
//  ProvidersTimeSlotModel.swift
//  Done
//
//  Created by Mazhar Hussain on 20/07/2022.
//

import Foundation
struct ProvidersTimeSlotModel : Codable {
    let status_code : Int?
    let message : String?
    let data : TimeSlotsData?

    enum CodingKeys: String, CodingKey {

        case status_code = "status_code"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(TimeSlotsData.self, forKey: .data)
    }

}
struct TimeSlotsData : Codable {
    let slots : [Slots]?

    enum CodingKeys: String, CodingKey {

        case slots = "slots"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slots = try values.decodeIfPresent([Slots].self, forKey: .slots)
    }

}
struct Slots : Codable {
    let slot_id : Int?
    let week_day : String?
    let slot_time_from : String?
    let slot_time_to : String?
    let provider_id : String?
    let available_resources : Int?
    let status : Int?
    var booking_status : Int?
    var isSelected = false
    

    enum CodingKeys: String, CodingKey {
       

        case slot_id = "slot_id"
        case week_day = "week_day"
        case slot_time_from = "slot_time_from"
        case slot_time_to = "slot_time_to"
        case provider_id = "provider_id"
        case available_resources = "available_resources"
        case status = "status"
        case booking_status = "booking_status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slot_id = try values.decodeIfPresent(Int.self, forKey: .slot_id)
        week_day = try values.decodeIfPresent(String.self, forKey: .week_day)
        slot_time_from = try values.decodeIfPresent(String.self, forKey: .slot_time_from)
        slot_time_to = try values.decodeIfPresent(String.self, forKey: .slot_time_to)
        provider_id = try values.decodeIfPresent(String.self, forKey: .provider_id)
        available_resources = try values.decodeIfPresent(Int.self, forKey: .available_resources)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        booking_status = try values.decodeIfPresent(Int.self, forKey: .booking_status)
    }

}


