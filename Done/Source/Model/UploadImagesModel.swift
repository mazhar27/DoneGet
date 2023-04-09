//
//  UploadImagesModel.swift
//  Done
//
//  Created by Mazhar Hussain on 26/07/2022.
//

import Foundation
struct UploadImagesModel : Codable {
    let status_code : Int?
    let message : String?
    let data : [String]?

    enum CodingKeys: String, CodingKey {

        case status_code = "status_code"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([String].self, forKey: .data)
    }

}
