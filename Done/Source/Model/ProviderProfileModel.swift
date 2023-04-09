//
//  ProviderProfileModel.swift
//  Done
//
//  Created by Dtech Mac on 12/09/2022.
//

import Foundation
struct providerProfileData : Codable {
    let status_code : Int?
    let message : String?
    let data : ProfileInnerData?

    enum CodingKeys: String, CodingKey {

        case status_code = "status_code"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(ProfileInnerData.self, forKey: .data)
    }

}
struct ProfileInnerData : Codable {
    let id : Int?
    var email : String?
    var phone : String?
    var name : String?
    let company_name : String?
    let reg_number : String?
    let skills : String?
    let experience : String?
    let details : String?
    var logo_image : String?
    let service_type : String?
    let address : String?
    let latitude : String?
    let longitude : String?
    let website : String?
    let main_services : [Main_services]?
    let provider_services : [Main_services]?
    let user_type : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case email = "email"
        case phone = "phone"
        case name = "name"
        case company_name = "company_name"
        case reg_number = "reg_number"
        case skills = "skills"
        case experience = "experience"
        case details = "details"
        case logo_image = "logo_image"
        case service_type = "service_type"
        case address = "address"
        case latitude = "latitude"
        case longitude = "longitude"
        case website = "website"
        case main_services = "main_services"
        case provider_services = "provider_services"
        case user_type = "user_type"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        company_name = try values.decodeIfPresent(String.self, forKey: .company_name)
        reg_number = try values.decodeIfPresent(String.self, forKey: .reg_number)
        skills = try values.decodeIfPresent(String.self, forKey: .skills)
        experience = try values.decodeIfPresent(String.self, forKey: .experience)
        details = try values.decodeIfPresent(String.self, forKey: .details)
        logo_image = try values.decodeIfPresent(String.self, forKey: .logo_image)
        service_type = try values.decodeIfPresent(String.self, forKey: .service_type)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        website = try values.decodeIfPresent(String.self, forKey: .website)
        main_services = try values.decodeIfPresent([Main_services].self, forKey: .main_services)
        //if main_services == nil {
            provider_services = try values.decodeIfPresent([Main_services].self, forKey: .provider_services)
        //}
        user_type = try values.decodeIfPresent(String.self, forKey: .user_type)
    }

}
struct Get_is_header : Codable {
    let service_id : Int?
    let service_title : String?
    let service_icon : String?

    enum CodingKeys: String, CodingKey {

        case service_id = "service_id"
        case service_title = "service_title"
        case service_icon = "service_icon"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        service_id = try values.decodeIfPresent(Int.self, forKey: .service_id)
        service_title = try values.decodeIfPresent(String.self, forKey: .service_title)
        service_icon = try values.decodeIfPresent(String.self, forKey: .service_icon)
    }

}

