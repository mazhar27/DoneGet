//
//  MyOrdersCustomerModel.swift
//  Done
//
//  Created by Mazhar Hussain on 22/08/2022.
//

import Foundation


    
    struct MyOrdersCustomerModel : Codable {
        let status_code : Int?
        let message : String?
        let data : Data?

        enum CodingKeys: String, CodingKey {

            case status_code = "status_code"
            case message = "message"
            case data = "data"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
            message = try values.decodeIfPresent(String.self, forKey: .message)
            data = try values.decodeIfPresent(Data.self, forKey: .data)
        }

    }

struct CustomerOrderData : Codable {
    let orders : [Orders]?
    let links : Links?

    enum CodingKeys: String, CodingKey {

        case orders = "orders"
        case links = "links"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        orders = try values.decodeIfPresent([Orders].self, forKey: .orders)
        links = try values.decodeIfPresent(Links.self, forKey: .links)
    }

}
struct Links : Codable {
    let current_page : Int?
    let first_page_url : String?
    let from : Int?
    let last_page : Int?
    let last_page_url : String?
    let next_page_url : String?
    let path : String?
    let per_page : Int?
    let prev_page_url : String?
    let to : Int?
    let total : Int?

    enum CodingKeys: String, CodingKey {

        case current_page = "current_page"
        case first_page_url = "first_page_url"
        case from = "from"
        case last_page = "last_page"
        case last_page_url = "last_page_url"
        case next_page_url = "next_page_url"
        case path = "path"
        case per_page = "per_page"
        case prev_page_url = "prev_page_url"
        case to = "to"
        case total = "total"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        current_page = try values.decodeIfPresent(Int.self, forKey: .current_page)
        first_page_url = try values.decodeIfPresent(String.self, forKey: .first_page_url)
        from = try values.decodeIfPresent(Int.self, forKey: .from)
        last_page = try values.decodeIfPresent(Int.self, forKey: .last_page)
        last_page_url = try values.decodeIfPresent(String.self, forKey: .last_page_url)
        next_page_url = try values.decodeIfPresent(String.self, forKey: .next_page_url)
        path = try values.decodeIfPresent(String.self, forKey: .path)
        per_page = try values.decodeIfPresent(Int.self, forKey: .per_page)
        prev_page_url = try values.decodeIfPresent(String.self, forKey: .prev_page_url)
        to = try values.decodeIfPresent(Int.self, forKey: .to)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
    }

}
struct Orders : Codable {
    let order_service_id : Int?
    let service_price : String?
    let service_time : String?
    let order_id : String?
    let service_id : String?
    let category_id : String?
    let provider_id : String?
    let order_status : String?
    let discount_percentage : Int?
    let vat_percentage : String?
    let order_number : Int?
    let payment_method : String?
    let service_title : String?
    let category_title : String?
    let provider_name : String?
    let logo : String?
    let invoice_url : String?
    let additional_invoice : String?
    let is_additional_invoice : Int?
    let order_discount_percentage : String?
    let order_vat_percentage : String?
    let order_time : String?
    let order_total : String?
    let transaction_id : String?
    let transaction_type : Int?
    let wallet_amount : String?
    let address_title : String?

    enum CodingKeys: String, CodingKey {

        case order_service_id = "order_service_id"
        case service_price = "service_price"
        case service_time = "service_time"
        case order_id = "order_id"
        case service_id = "service_id"
        case category_id = "category_id"
        case provider_id = "provider_id"
        case order_status = "order_status"
        case discount_percentage = "discount_percentage"
        case vat_percentage = "vat_percentage"
        case order_number = "order_number"
        case payment_method = "payment_method"
        case service_title = "service_title"
        case category_title = "category_title"
        case provider_name = "provider_name"
        case logo = "logo"
        case invoice_url = "invoice_url"
        case additional_invoice = "additional_invoice"
        case is_additional_invoice = "is_additional_invoice"
        case order_discount_percentage = "order_discount_percentage"
        case order_vat_percentage = "order_vat_percentage"
        case order_time = "order_time"
        case order_total = "order_total"
        case transaction_id = "transaction_id"
        case transaction_type = "transaction_type"
        case wallet_amount = "wallet_amount"
        case address_title = "address_title"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        order_service_id = try values.decodeIfPresent(Int.self, forKey: .order_service_id)
        service_price = try values.decodeIfPresent(String.self, forKey: .service_price)
        service_time = try values.decodeIfPresent(String.self, forKey: .service_time)
        order_id = try values.decodeIfPresent(String.self, forKey: .order_id)
        service_id = try values.decodeIfPresent(String.self, forKey: .service_id)
        category_id = try values.decodeIfPresent(String.self, forKey: .category_id)
        provider_id = try values.decodeIfPresent(String.self, forKey: .provider_id)
        order_status = try values.decodeIfPresent(String.self, forKey: .order_status)
        discount_percentage = try values.decodeIfPresent(Int.self, forKey: .discount_percentage)
        vat_percentage = try values.decodeIfPresent(String.self, forKey: .vat_percentage)
        order_number = try values.decodeIfPresent(Int.self, forKey: .order_number)
        payment_method = try values.decodeIfPresent(String.self, forKey: .payment_method)
        service_title = try values.decodeIfPresent(String.self, forKey: .service_title)
        category_title = try values.decodeIfPresent(String.self, forKey: .category_title)
        provider_name = try values.decodeIfPresent(String.self, forKey: .provider_name)
        logo = try values.decodeIfPresent(String.self, forKey: .logo)
        invoice_url = try values.decodeIfPresent(String.self, forKey: .invoice_url)
        additional_invoice = try values.decodeIfPresent(String.self, forKey: .additional_invoice)
        is_additional_invoice = try values.decodeIfPresent(Int.self, forKey: .is_additional_invoice)
        order_discount_percentage = try values.decodeIfPresent(String.self, forKey: .order_discount_percentage)
        order_vat_percentage = try values.decodeIfPresent(String.self, forKey: .order_vat_percentage)
        order_time = try values.decodeIfPresent(String.self, forKey: .order_time)
        order_total = try values.decodeIfPresent(String.self, forKey: .order_total)
        transaction_id = try values.decodeIfPresent(String.self, forKey: .transaction_id)
        transaction_type = try values.decodeIfPresent(Int.self, forKey: .transaction_type)
        wallet_amount = try values.decodeIfPresent(String.self, forKey: .wallet_amount)
        address_title = try values.decodeIfPresent(String.self, forKey: .address_title)
    }

}


