//
//  CouponModel.swift
//  Done
//
//  Created by Mazhar Hussain on 15/08/2022.
//

import Foundation

struct CouponModel : Codable {
    let status_code : Int?
    let message : String?
    let data : CouponData?
    

    enum CodingKeys: String, CodingKey {

        case status_code = "status_code"
        case message = "message"
        case data = "data"
     
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(CouponData.self, forKey: .data)
       
    }

}
struct CouponData : Codable {
    let services : [Services]?
    let extras : Extras?
    let coupon_error : [Coupon_error]?
   
    let wallet : Wallet?

    enum CodingKeys: String, CodingKey {

        case services = "services"
        case extras = "extras"
        case coupon_error = "coupon_error"
        case wallet = "wallet"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        services = try values.decodeIfPresent([Services].self, forKey: .services)
        extras = try values.decodeIfPresent(Extras.self, forKey: .extras)
        coupon_error = try values.decodeIfPresent([Coupon_error].self, forKey: .coupon_error)
        wallet = try values.decodeIfPresent(Wallet.self, forKey: .wallet)
    }

}
struct Wallet : Codable {
    let wallet_id : Int?
    let user_id : Int?
    let balance : Double?
    let created_at : String?
    let updated_at : String?

    enum CodingKeys: String, CodingKey {

        case wallet_id = "wallet_id"
        case user_id = "user_id"
        case balance = "balance"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        wallet_id = try values.decodeIfPresent(Int.self, forKey: .wallet_id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        balance = try values.decodeIfPresent(Double.self, forKey: .balance)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}

struct Extras : Codable {
    let services_total : String?
    let discounted_total : String?
    let discount_amount : String?
    let vat_percentage : String?
    let vat_amount : String?

    enum CodingKeys: String, CodingKey {

        case services_total = "services_total"
        case discounted_total = "discounted_total"
        case discount_amount = "discount_amount"
        case vat_percentage = "vat_percentage"
        case vat_amount = "vat_amount"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        services_total = try values.decodeIfPresent(String.self, forKey: .services_total)
        discounted_total = try values.decodeIfPresent(String.self, forKey: .discounted_total)
        discount_amount = try values.decodeIfPresent(String.self, forKey: .discount_amount)
        vat_percentage = try values.decodeIfPresent(String.self, forKey: .vat_percentage)
        vat_amount = try values.decodeIfPresent(String.self, forKey: .vat_amount)
    }

}
struct Services : Codable {
    let address_latitude : String?
    let address_longitude : String?
    let address_title : String?
    let images : [String?]?
    let cart_service_id : Int?
    let category_id : Int?
    var coupon_code : String?
    var coupon_id : Int?
    let date_time : String?
    let option_id : [Int]?
    let service_type : Int?
    let answers : [String]?
    let provider_id : Int?
    let service_id : Int?
    let service_instructions : String?
    let service_price : String?
    let slot_id : Int?
    let discount_percentage : String?
    let discounted_amount : String?
    let categoryName : String?
    let serviceName : String?
    let serviceImage : String?
    
    
   
    enum CodingKeys: String, CodingKey {

        case address_latitude = "address_latitude"
        case address_longitude = "address_longitude"
        case address_title = "address_title"
        case images = "images"
        case cart_service_id = "cart_service_id"
        case category_id = "category_id"
        case coupon_code = "coupon_code"
        case coupon_id = "coupon_id"
        case date_time = "date_time"
        case option_id = "option_id"
        case service_type = "service_type"
        case answers = "answers"
        case provider_id = "provider_id"
        case service_id = "service_id"
        case service_instructions = "service_instructions"
        case service_price = "service_price"
        case slot_id = "slot_id"
        case discount_percentage = "discount_percentage"
        case discounted_amount = "discounted_amount"
        case categoryName = "categoryName"
        case serviceName = "serviceName"
        case serviceImage = "serviceImage"
    }
    init(address_latitude : String, address_longitude : String, address_title : String,images : [String],
         cart_service_id : Int, category_id : Int, coupon_code : String, coupon_id : Int, date_time : String, option_id : [Int], service_type : Int, answers : [String], provider_id : Int, service_id : Int, service_instructions : String, service_price : String, slot_id : Int, discount_percentage : String, discounted_amount : String, categoryName : String,serviceName : String, serviceImage: String){
        self.address_latitude = address_latitude
        self.address_longitude = address_longitude
        self.address_title = address_title
        self.images = images
        self.cart_service_id = cart_service_id
        self.category_id = category_id
        self.coupon_code = coupon_code
        self.coupon_id = coupon_id
        self.date_time = date_time
        self.option_id = option_id
        self.service_type = service_type
        self.answers = answers
        self.provider_id = provider_id
        self.service_id = service_id
        self.service_instructions = service_instructions
        self.service_price = service_price
        self.slot_id = slot_id
        self.discount_percentage = discount_percentage
        self.discounted_amount = discounted_amount
        self.categoryName = categoryName
        self.serviceName = serviceName
        self.serviceImage = serviceImage
        
        
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        address_latitude = try values.decodeIfPresent(String.self, forKey: .address_latitude)
        address_longitude = try values.decodeIfPresent(String.self, forKey: .address_longitude)
        address_title = try values.decodeIfPresent(String.self, forKey: .address_title)
        images = try values.decodeIfPresent([String?].self, forKey: .images) ?? [""]
        cart_service_id = try values.decodeIfPresent(Int.self, forKey: .cart_service_id)
        category_id = try values.decodeIfPresent(Int.self, forKey: .category_id)
        coupon_code = try values.decodeIfPresent(String.self, forKey: .coupon_code)
        coupon_id = try values.decodeIfPresent(Int.self, forKey: .coupon_id)
        date_time = try values.decodeIfPresent(String.self, forKey: .date_time) ?? ""
        option_id = try values.decodeIfPresent([Int].self, forKey: .option_id)
        service_type = try values.decodeIfPresent(Int.self, forKey: .service_type)
        answers = try values.decodeIfPresent([String].self, forKey: .answers)
        provider_id = try values.decodeIfPresent(Int.self, forKey: .provider_id)
        service_id = try values.decodeIfPresent(Int.self, forKey: .service_id)
        service_instructions = try values.decodeIfPresent(String.self, forKey: .service_instructions) ?? ""
        service_price = try values.decodeIfPresent(String.self, forKey: .service_price)
        slot_id = try values.decodeIfPresent(Int.self, forKey: .slot_id)
        discount_percentage = try values.decodeIfPresent(String.self, forKey: .discount_percentage)
        discounted_amount = try values.decodeIfPresent(String.self, forKey: .discounted_amount)
        categoryName = try values.decodeIfPresent(String.self, forKey: .categoryName)
        serviceName = try values.decodeIfPresent(String.self, forKey: .serviceName)
        serviceImage = try values.decodeIfPresent(String.self, forKey: .serviceImage)
    }

}

struct ServicesCart : Codable {
    var address_latitude = ""
    var address_longitude = ""
    var address_title = ""
    var images = [String]()
    var cart_service_id = -1
    var category_id = -1
    var coupon_code = ""
    var coupon_id = -1
    var date_time = ""
    var option_id = [Int]()
    var service_type = -1
    var answers = [String]()
    var provider_id = -1
    var service_id = -1
    var service_instructions = ""
    var service_price = ""
    var slot_id = -1
    var discount_percentage = ""
    var discounted_amount = ""
    var categoryName = ""
    var serviceName  = ""
   
}
struct ServicesInputParam : Codable {
    var address_latitude = ""
    var address_longitude = ""
    var address_title = ""
    var images = [String]()
    var cart_service_id = -1
    var category_id = -1
    var coupon_code = ""
    var coupon_id = -1
    var date_time = ""
    var option_id = [Int]()
    var service_type = -1
    var answers = [String]()
    var provider_id = -1
    var service_id = -1
    var service_instructions = ""
    var service_price = ""
    var slot_id = -1
}
struct Coupon_error : Codable {
    let coupon_code : String?
    let is_expired : Int?
    let not_found : Int?
    let customer_used : Int?

    enum CodingKeys: String, CodingKey {

        case coupon_code = "coupon_code"
        case is_expired = "is_expired"
        case not_found = "not_found"
        case customer_used = "customer_used"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coupon_code = try values.decodeIfPresent(String.self, forKey: .coupon_code)
        is_expired = try values.decodeIfPresent(Int.self, forKey: .is_expired)
        not_found = try values.decodeIfPresent(Int.self, forKey: .not_found)
        customer_used = try values.decodeIfPresent(Int.self, forKey: .customer_used)
    }

}


