//
//  ProviderJobsListModel.swift
//  Done
//
//  Created by Mazhar Hussain on 08/09/2022.
//

import Foundation

struct ProviderJobsData : Codable {
    let jobs : [Jobs]?
    let links : Links?

    enum CodingKeys: String, CodingKey {

        case jobs = "jobs"
        case links = "links"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        jobs = try values.decodeIfPresent([Jobs].self, forKey: .jobs)
        links = try values.decodeIfPresent(Links.self, forKey: .links)
    }

}
struct Jobs : Codable {
    let order_number : Int?
    let order_status : String?
    let name : String?
    let phone : String?
    let service_title : String?
    let category_title : String?
    let address_title : String?
    let order_vat_percentage : String?
    let order_discount_percentage : String?
    let service_price : String?
    let service_time : String?
    let transaction_id : String?
    let order_id : String?
    let order_service_id : Int?
    let payment_type : String?
    let base_price : String?
    let discount_percentage : Int?
    let discount_amount : Double?
    let vat_percentage : String?
    let vat_amount : Double?
    let total_amount : String?

    enum CodingKeys: String, CodingKey {

        case order_number = "order_number"
        case order_status = "order_status"
        case name = "name"
        case phone = "phone"
        case service_title = "service_title"
        case category_title = "category_title"
        case address_title = "address_title"
        case order_vat_percentage = "order_vat_percentage"
        case order_discount_percentage = "order_discount_percentage"
        case service_price = "service_price"
        case service_time = "service_time"
        case transaction_id = "transaction_id"
        case order_id = "order_id"
        case order_service_id = "order_service_id"
        case payment_type = "payment_type"
        case base_price = "base_price"
        case discount_percentage = "discount_percentage"
        case discount_amount = "discount_amount"
        case vat_percentage = "vat_percentage"
        case vat_amount = "vat_amount"
        case total_amount = "total_amount"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        order_number = try values.decodeIfPresent(Int.self, forKey: .order_number)
        order_status = try values.decodeIfPresent(String.self, forKey: .order_status)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        service_title = try values.decodeIfPresent(String.self, forKey: .service_title)
        category_title = try values.decodeIfPresent(String.self, forKey: .category_title)
        address_title = try values.decodeIfPresent(String.self, forKey: .address_title)
        order_vat_percentage = try values.decodeIfPresent(String.self, forKey: .order_vat_percentage)
        order_discount_percentage = try values.decodeIfPresent(String.self, forKey: .order_discount_percentage)
        service_price = try values.decodeIfPresent(String.self, forKey: .service_price)
        service_time = try values.decodeIfPresent(String.self, forKey: .service_time)
        transaction_id = try values.decodeIfPresent(String.self, forKey: .transaction_id)
        order_id = try values.decodeIfPresent(String.self, forKey: .order_id)
        order_service_id = try values.decodeIfPresent(Int.self, forKey: .order_service_id)
        payment_type = try values.decodeIfPresent(String.self, forKey: .payment_type)
        base_price = try values.decodeIfPresent(String.self, forKey: .base_price)
        discount_percentage = try values.decodeIfPresent(Int.self, forKey: .discount_percentage)
        discount_amount = try values.decodeIfPresent(Double.self, forKey: .discount_amount)
        vat_percentage = try values.decodeIfPresent(String.self, forKey: .vat_percentage)
        vat_amount = try values.decodeIfPresent(Double.self, forKey: .vat_amount)
        total_amount = try values.decodeIfPresent(String.self, forKey: .total_amount)
    }

}
struct JobDetailsData : Codable {
    let service_title : String?
    let name : String?
    let phone : String?
    let address : String?
    let latitude : String?
    let longitude : String?
    let teansaction : String?
    let time : String?
    let payment_type : String?
    let service_type : String?
    let description : String?
    let question_answers : [String]?
    let images : [String]?
    let order_id : String?
    let order_number : String?
    let order_service_id : String?
    let payment_details : JobPaymentDetails?
    let is_additional_invoice_marked : Int?
    let is_complete_allowed : Int?
    let coupon_code : String?
    let invoice_url : String?
    let additional_invoice_url : String?

    enum CodingKeys: String, CodingKey {

        case service_title = "service_title"
        case name = "name"
        case phone = "phone"
        case address = "address"
        case latitude = "latitude"
        case longitude = "longitude"
        case teansaction = "teansaction"
        case time = "time"
        case payment_type = "payment_type"
        case service_type = "service_type"
        case description = "description"
        case question_answers = "question_answers"
        case images = "images"
        case order_id = "order_id"
        case order_number = "order_number"
        case order_service_id = "order_service_id"
        case payment_details = "payment_details"
        case is_additional_invoice_marked = "is_additional_invoice_marked"
        case is_complete_allowed = "is_complete_allowed"
        case coupon_code = "coupon_code"
        case invoice_url = "invoice_url"
        case additional_invoice_url = "additional_invoice_url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        service_title = try values.decodeIfPresent(String.self, forKey: .service_title)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        teansaction = try values.decodeIfPresent(String.self, forKey: .teansaction)
        time = try values.decodeIfPresent(String.self, forKey: .time)
        payment_type = try values.decodeIfPresent(String.self, forKey: .payment_type)
        service_type = try values.decodeIfPresent(String.self, forKey: .service_type)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        question_answers = try values.decodeIfPresent([String].self, forKey: .question_answers)
        images = try values.decodeIfPresent([String].self, forKey: .images)
        order_id = try values.decodeIfPresent(String.self, forKey: .order_id)
        order_number = try values.decodeIfPresent(String.self, forKey: .order_number)
        order_service_id = try values.decodeIfPresent(String.self, forKey: .order_service_id)
        payment_details = try values.decodeIfPresent(JobPaymentDetails.self, forKey: .payment_details)
        is_additional_invoice_marked = try values.decodeIfPresent(Int.self, forKey: .is_additional_invoice_marked)
        is_complete_allowed = try values.decodeIfPresent(Int.self, forKey: .is_complete_allowed)
        coupon_code = try values.decodeIfPresent(String.self, forKey: .coupon_code)
        invoice_url = try values.decodeIfPresent(String.self, forKey: .invoice_url)
        additional_invoice_url = try values.decodeIfPresent(String.self, forKey: .additional_invoice_url)
    }

}

struct JobPaymentDetails : Codable {
    let base_price : String?
    let discount_percentage : String?
    let discount_amount : String?
    let additional_invoice : String?
    let additional_invoice_vat : String?
    let additional_invoice_discount : String?
    let vat_percentage : String?
    let vat_amount : String?
    let total_amount : String?
    let amount_to_be_collected : String?

    enum CodingKeys: String, CodingKey {

        case base_price = "base_price"
        case discount_percentage = "discount_percentage"
        case discount_amount = "discount_amount"
        case additional_invoice = "additional_invoice"
        case additional_invoice_vat = "additional_invoice_vat"
        case additional_invoice_discount = "additional_invoice_discount"
        case vat_percentage = "vat_percentage"
        case vat_amount = "vat_amount"
        case total_amount = "total_amount"
        case amount_to_be_collected = "amount_to_be_collected"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        base_price = try values.decodeIfPresent(String.self, forKey: .base_price)
        discount_percentage = try values.decodeIfPresent(String.self, forKey: .discount_percentage)
        discount_amount = try values.decodeIfPresent(String.self, forKey: .discount_amount)
        additional_invoice = try values.decodeIfPresent(String.self, forKey: .additional_invoice)
        additional_invoice_vat = try values.decodeIfPresent(String.self, forKey: .additional_invoice_vat)
        additional_invoice_discount = try values.decodeIfPresent(String.self, forKey: .additional_invoice_discount)
        vat_percentage = try values.decodeIfPresent(String.self, forKey: .vat_percentage)
        vat_amount = try values.decodeIfPresent(String.self, forKey: .vat_amount)
        total_amount = try values.decodeIfPresent(String.self, forKey: .total_amount)
        amount_to_be_collected = try values.decodeIfPresent(String.self, forKey: .amount_to_be_collected)
    }

}

struct ProviderJobDetailsData : Codable {
    let service_title : String?
    let category_title : String?
    let name : String?
    let phone : String?
    let address : String?
    let latitude : String?
    let longitude : String?
    let teansaction : String?
    let time : String?
    let payment_type : String?
    let service_type : String?
    let description : String?
    let question_answers : [Question_answers]?
    let images : [imagesData]?
    let order_id : String?
    let order_number : String?
    let order_service_id : String?
    let payment_details : Payment_details?
    let is_additional_invoice_marked : Int?
    let is_complete_allowed : Int?
    let coupon_code : String?
    let invoice_url : String?
    let additional_invoice_url : String?
    let reject_reason : String?

    enum CodingKeys: String, CodingKey {

        case service_title = "service_title"
        case category_title = "category_title"
        case name = "name"
        case phone = "phone"
        case address = "address"
        case latitude = "latitude"
        case longitude = "longitude"
        case teansaction = "teansaction"
        case time = "time"
        case payment_type = "payment_type"
        case service_type = "service_type"
        case description = "description"
        case question_answers = "question_answers"
        case images = "images"
        case order_id = "order_id"
        case order_number = "order_number"
        case order_service_id = "order_service_id"
        case payment_details = "payment_details"
        case is_additional_invoice_marked = "is_additional_invoice_marked"
        case is_complete_allowed = "is_complete_allowed"
        case coupon_code = "coupon_code"
        case invoice_url = "invoice_url"
        case additional_invoice_url = "additional_invoice_url"
        case reject_reason = "reject_reason"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        service_title = try values.decodeIfPresent(String.self, forKey: .service_title)
        category_title = try values.decodeIfPresent(String.self, forKey: .category_title)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        teansaction = try values.decodeIfPresent(String.self, forKey: .teansaction)
        time = try values.decodeIfPresent(String.self, forKey: .time)
        payment_type = try values.decodeIfPresent(String.self, forKey: .payment_type)
        service_type = try values.decodeIfPresent(String.self, forKey: .service_type)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        question_answers = try values.decodeIfPresent([Question_answers].self, forKey: .question_answers)
        images = try values.decodeIfPresent([imagesData].self, forKey: .images)
        order_id = try values.decodeIfPresent(String.self, forKey: .order_id)
        order_number = try values.decodeIfPresent(String.self, forKey: .order_number)
        order_service_id = try values.decodeIfPresent(String.self, forKey: .order_service_id)
        payment_details = try values.decodeIfPresent(Payment_details.self, forKey: .payment_details)
        is_additional_invoice_marked = try values.decodeIfPresent(Int.self, forKey: .is_additional_invoice_marked)
        is_complete_allowed = try values.decodeIfPresent(Int.self, forKey: .is_complete_allowed)
        coupon_code = try values.decodeIfPresent(String.self, forKey: .coupon_code)
        invoice_url = try values.decodeIfPresent(String.self, forKey: .invoice_url)
        additional_invoice_url = try values.decodeIfPresent(String.self, forKey: .additional_invoice_url)
        reject_reason = try values.decodeIfPresent(String.self, forKey: .reject_reason)
    }

}
struct Payment_details : Codable {
    let base_price : String?
    let discount_percentage : String?
    let discount_amount : String?
    let additional_invoice : String?
    let additional_invoice_vat : String?
    let additional_invoice_discount : String?
    let vat_percentage : String?
    let vat_amount : String?
    let total_amount : String?
    let amount_to_be_collected : String?
    let wallet_amount : String?

    enum CodingKeys: String, CodingKey {

        case base_price = "base_price"
        case discount_percentage = "discount_percentage"
        case discount_amount = "discount_amount"
        case additional_invoice = "additional_invoice"
        case additional_invoice_vat = "additional_invoice_vat"
        case additional_invoice_discount = "additional_invoice_discount"
        case vat_percentage = "vat_percentage"
        case vat_amount = "vat_amount"
        case total_amount = "total_amount"
        case amount_to_be_collected = "amount_to_be_collected"
        case wallet_amount = "wallet_amount"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        base_price = try values.decodeIfPresent(String.self, forKey: .base_price)
        discount_percentage = try values.decodeIfPresent(String.self, forKey: .discount_percentage)
        discount_amount = try values.decodeIfPresent(String.self, forKey: .discount_amount)
        additional_invoice = try values.decodeIfPresent(String.self, forKey: .additional_invoice)
        additional_invoice_vat = try values.decodeIfPresent(String.self, forKey: .additional_invoice_vat)
        additional_invoice_discount = try values.decodeIfPresent(String.self, forKey: .additional_invoice_discount)
        vat_percentage = try values.decodeIfPresent(String.self, forKey: .vat_percentage)
        vat_amount = try values.decodeIfPresent(String.self, forKey: .vat_amount)
        total_amount = try values.decodeIfPresent(String.self, forKey: .total_amount)
        amount_to_be_collected = try values.decodeIfPresent(String.self, forKey: .amount_to_be_collected)
        wallet_amount = try values.decodeIfPresent(String?.self, forKey: .wallet_amount) ?? ""
    }

}
struct Question_answers : Codable {
    let answers_detail : String?
    let question_title : String?
    let order_service_id : String?
    let question_id : Int?

    enum CodingKeys: String, CodingKey {

        case answers_detail = "answers_detail"
        case question_title = "question_title"
        case order_service_id = "order_service_id"
        case question_id = "question_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        answers_detail = try values.decodeIfPresent(String.self, forKey: .answers_detail)
        question_title = try values.decodeIfPresent(String.self, forKey: .question_title)
        order_service_id = try values.decodeIfPresent(String.self, forKey: .order_service_id)
        question_id = try values.decodeIfPresent(Int.self, forKey: .question_id)
    }

}
struct imagesData : Codable {
    let order_service_id : String?
    let image_title : String?
   
    enum CodingKeys: String, CodingKey {

        case order_service_id = "order_service_id"
        case image_title = "image_title"
        
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        order_service_id = try values.decodeIfPresent(String.self, forKey: .order_service_id)
        image_title = try values.decodeIfPresent(String.self, forKey: .image_title)
       
    }

}

struct JobStatusData : Codable {
    let order_service_id : Int?
    let service_price : String?
    let service_time : String?
    let order_instructions : String?
    let order_status : Int?
    let is_rejected : Int?
    let status_text : String?
    let service_type : Int?
    let service_id : Int?
    let category_id : Int?
    let customer_id : Int?
    let provider_id : Int?
    let address_title : String?
    let address_latitude : String?
    let address_longitude : String?
    let slot_id : Int?
    let order_id : Int?
    let coupon_id : Int?
    let coupon_code : String?
    let comission_amount : Int?
    let discount_percentage : Int?
    let vat_percentage : String?
    let vat_amount : String?
    let wallet_amount : String?
    let transaction_type : Int?
    let created_at : String?
    let updated_at : String?
    let head_service_id : Int?
    let is_disputed : String?
    let dispute_text : String?
    let deleted_at : String?

    enum CodingKeys: String, CodingKey {

        case order_service_id = "order_service_id"
        case service_price = "service_price"
        case service_time = "service_time"
        case order_instructions = "order_instructions"
        case order_status = "order_status"
        case is_rejected = "is_rejected"
        case status_text = "status_text"
        case service_type = "service_type"
        case service_id = "service_id"
        case category_id = "category_id"
        case customer_id = "customer_id"
        case provider_id = "provider_id"
        case address_title = "address_title"
        case address_latitude = "address_latitude"
        case address_longitude = "address_longitude"
        case slot_id = "slot_id"
        case order_id = "order_id"
        case coupon_id = "coupon_id"
        case coupon_code = "coupon_code"
        case comission_amount = "comission_amount"
        case discount_percentage = "discount_percentage"
        case vat_percentage = "vat_percentage"
        case vat_amount = "vat_amount"
        case wallet_amount = "wallet_amount"
        case transaction_type = "transaction_type"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case head_service_id = "head_service_id"
        case is_disputed = "is_disputed"
        case dispute_text = "dispute_text"
        case deleted_at = "deleted_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        order_service_id = try values.decodeIfPresent(Int.self, forKey: .order_service_id)
        service_price = try values.decodeIfPresent(String.self, forKey: .service_price)
        service_time = try values.decodeIfPresent(String.self, forKey: .service_time)
        order_instructions = try values.decodeIfPresent(String.self, forKey: .order_instructions)
        order_status = try values.decodeIfPresent(Int?.self, forKey: .order_status) ?? 0
        is_rejected = try values.decodeIfPresent(Int.self, forKey: .is_rejected)
        status_text = try values.decodeIfPresent(String.self, forKey: .status_text)
        service_type = try values.decodeIfPresent(Int.self, forKey: .service_type)
        service_id = try values.decodeIfPresent(Int.self, forKey: .service_id)
        category_id = try values.decodeIfPresent(Int.self, forKey: .category_id)
        customer_id = try values.decodeIfPresent(Int.self, forKey: .customer_id)
        provider_id = try values.decodeIfPresent(Int.self, forKey: .provider_id)
        address_title = try values.decodeIfPresent(String.self, forKey: .address_title)
        address_latitude = try values.decodeIfPresent(String.self, forKey: .address_latitude)
        address_longitude = try values.decodeIfPresent(String.self, forKey: .address_longitude)
        slot_id = try values.decodeIfPresent(Int.self, forKey: .slot_id)
        order_id = try values.decodeIfPresent(Int.self, forKey: .order_id)
        coupon_id = try values.decodeIfPresent(Int.self, forKey: .coupon_id)
        coupon_code = try values.decodeIfPresent(String.self, forKey: .coupon_code)
        comission_amount = try values.decodeIfPresent(Int.self, forKey: .comission_amount)
        discount_percentage = try values.decodeIfPresent(Int.self, forKey: .discount_percentage)
        vat_percentage = try values.decodeIfPresent(String.self, forKey: .vat_percentage)
        vat_amount = try values.decodeIfPresent(String.self, forKey: .vat_amount)
        wallet_amount = try values.decodeIfPresent(String.self, forKey: .wallet_amount)
        transaction_type = try values.decodeIfPresent(Int.self, forKey: .transaction_type)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        head_service_id = try values.decodeIfPresent(Int.self, forKey: .head_service_id)
        is_disputed = try values.decodeIfPresent(String.self, forKey: .is_disputed)
        dispute_text = try values.decodeIfPresent(String.self, forKey: .dispute_text)
        deleted_at = try values.decodeIfPresent(String.self, forKey: .deleted_at)
    }

}





