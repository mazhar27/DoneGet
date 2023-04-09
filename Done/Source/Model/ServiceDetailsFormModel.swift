//
//  ServiceDetailsFormModel.swift
//  Done
//
//  Created by Mazhar Hussain on 14/07/2022.
//

import Foundation


struct ServiceDetailsFormModel : Codable {
    let status_code : Int?
    let message : String?
    let data : FormData?

    enum CodingKeys: String, CodingKey {

        case status_code = "status_code"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(FormData.self, forKey: .data)
    }

}
struct FormData : Codable {
    let service_questions : [Service_questions]?
    let service : Service?
    let option_text : String?

    enum CodingKeys: String, CodingKey {

        case service_questions = "service_questions"
        case service = "service"
        case option_text = "option_text"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        service_questions = try values.decodeIfPresent([Service_questions].self, forKey: .service_questions)
        service = try values.decodeIfPresent(Service.self, forKey: .service)
        option_text = try values.decodeIfPresent(String.self, forKey: .option_text)
    }

}

struct Service_questions : Codable {
    let question_title : String?
    let question_id : Int?
    let optiontree : [Optiontree]?

    enum CodingKeys: String, CodingKey {

        case question_title = "question_title"
        case question_id = "question_id"
        case optiontree = "optiontree"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        question_title = try values.decodeIfPresent(String.self, forKey: .question_title)
        question_id = try values.decodeIfPresent(Int.self, forKey: .question_id)
        optiontree = try values.decodeIfPresent([Optiontree].self, forKey: .optiontree)
    }

}
struct Questiontree : Codable {
    let question_title : String?
    let question_id : Int?
    let option_id : Int?
    let optiontree : [Optiontree]?

    enum CodingKeys: String, CodingKey {

        case question_title = "question_title"
        case question_id = "question_id"
        case option_id = "option_id"
        case optiontree = "optiontree"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        question_title = try values.decodeIfPresent(String.self, forKey: .question_title)
        question_id = try values.decodeIfPresent(Int.self, forKey: .question_id)
        option_id = try values.decodeIfPresent(Int.self, forKey: .option_id)
        optiontree = try values.decodeIfPresent([Optiontree].self, forKey: .optiontree)
    }

}
struct Service : Codable {
    let service_title : String?
    let is_home : Int?
    let is_pick : Int?
    let service_id : Int?
    let head_service_id : Int?
    let get_is_header : Get_is_header?

    enum CodingKeys: String, CodingKey {

        case service_id = "service_id"
        case head_service_id = "head_service_id"
        case service_title = "service_title"
        case get_is_header = "get_is_header"
        case is_home = "is_home"
        case is_pick = "is_pick"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        service_id = try values.decodeIfPresent(Int.self, forKey: .service_id)
        head_service_id = try values.decodeIfPresent(Int.self, forKey: .head_service_id)
        service_title = try values.decodeIfPresent(String.self, forKey: .service_title)
        get_is_header = try values.decodeIfPresent(Get_is_header.self, forKey: .get_is_header)
        is_home = try values.decodeIfPresent(Int.self, forKey: .is_home)
        is_pick = try values.decodeIfPresent(Int.self, forKey: .is_pick)
    }

}
struct Optiontree : Codable {
    let option : String?
    let id : Int?
    let question_id : Int?
    let questiontree : [Questiontree]?

    enum CodingKeys: String, CodingKey {

        case option = "option"
        case id = "id"
        case question_id = "question_id"
        case questiontree = "questiontree"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        option = try values.decodeIfPresent(String.self, forKey: .option)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        question_id = try values.decodeIfPresent(Int.self, forKey: .question_id)
        questiontree = try values.decodeIfPresent([Questiontree].self, forKey: .questiontree)
    }

}
class AMPGenericObject: NSObject {
    
    var name:String?
    var selectedOption : String = ""
    var parentName:String?
    var canBeExpanded = false // Bool to determine whether the cell can be expanded
    var isExpanded = false    // Bool to determine whether the cell is expanded
    var level:Int?            // Indendation level of tabelview
    var type:Int?
    var questionId: Int?
    var optionId: Int?
    var children:[AMPGenericObject] = []
    var optiontree:[Optiontree] = []
    
    enum ObjectType:Int{
        case object_TYPE_REGION = 0
        case object_TYPE_LOCATION
        case object_TYPE_USERS
    }

}
struct QuestionAnswerHandeling: Codable {
    var optionId : Int?
    var questionId : Int?
}




