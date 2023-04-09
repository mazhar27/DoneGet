//
//  APIResponse.swift
//  Done
//
//  Created by Mazhar Hussain on 6/19/22.
//

import Foundation

struct BaseModel<T: Codable> : Codable {
    
    let code : Int?
    let success: Bool?
    let message : String?
    let data : T?
    
    enum CodingKeys: String, CodingKey {
        case code = "status_code"
        case message
        case data
        case success
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(T.self, forKey: .data) ?? T(from: decoder)
    }
    
}

struct APIResponse: Codable {
    let code : Int?
    let success: Bool?
    let message : String?
    let data: [String: Int?]?
    
    
    enum CodingKeys: String, CodingKey {
        case code = "status_code"
        case success
        case message
        case data
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([String: Int?].self, forKey: .data)
    }
    
}

struct APIResponseGeneric: Codable {
    let code : Int?
    let success: Bool?
    let message : String?
    
    enum CodingKeys: String, CodingKey {
        case code = "status_code"
        case success
        case message
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        
    }
    
}

