//
//  AdditionalInvoiceModel.swift
//  Done
//
//  Created by Mazhar Hussain on 30/08/2022.
//

import Foundation

    
    struct AdditionalInvoiceData : Codable {
        let additional_cost_id : Int?
        let additional_remarks : String?
        let additional_price : String?
        let additional_cost_status : Int?
        let additional_cost_vat_amount : String?
        let wallet_amount : Double?
        let logo_image : String?
        let service_title : String?
        let category_title : String?
        let provider_name : String?
        let order_service_id : Int?
        let vat_percentage : String?
        let discount_percentage : String?
        let additional_cost_discount_amount : String?
        let discount_amount : String?
        let vat_amount : String?
        let total_amount : String?
        let order_number : Int?
        let service_time : String?
        let address_title : String?
        let payment_method : String?
        let order_total : String?

        enum CodingKeys: String, CodingKey {

            case additional_cost_id = "additional_cost_id"
            case additional_remarks = "additional_remarks"
            case additional_price = "additional_price"
            case additional_cost_status = "additional_cost_status"
            case additional_cost_vat_amount = "additional_cost_vat_amount"
            case wallet_amount = "wallet_amount"
            case logo_image = "logo_image"
            case service_title = "service_title"
            case category_title = "category_title"
            case provider_name = "provider_name"
            case order_service_id = "order_service_id"
            case vat_percentage = "vat_percentage"
            case discount_percentage = "discount_percentage"
            case additional_cost_discount_amount = "additional_cost_discount_amount"
            case discount_amount = "discount_amount"
            case vat_amount = "vat_amount"
            case total_amount = "total_amount"
            case order_number = "order_number"
            case service_time = "service_time"
            case address_title = "address_title"
            case payment_method = "payment_method"
            case order_total = "order_total"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            additional_cost_id = try values.decodeIfPresent(Int.self, forKey: .additional_cost_id)
            additional_remarks = try values.decodeIfPresent(String.self, forKey: .additional_remarks)
            additional_price = try values.decodeIfPresent(String.self, forKey: .additional_price)
            additional_cost_status = try values.decodeIfPresent(Int.self, forKey: .additional_cost_status)
            additional_cost_vat_amount = try values.decodeIfPresent(String.self, forKey: .additional_cost_vat_amount)
            wallet_amount = try values.decodeIfPresent(Double.self, forKey: .wallet_amount)
            logo_image = try values.decodeIfPresent(String.self, forKey: .logo_image)
            service_title = try values.decodeIfPresent(String.self, forKey: .service_title)
            category_title = try values.decodeIfPresent(String.self, forKey: .category_title)
            provider_name = try values.decodeIfPresent(String.self, forKey: .provider_name)
            order_service_id = try values.decodeIfPresent(Int.self, forKey: .order_service_id)
            vat_percentage = try values.decodeIfPresent(String.self, forKey: .vat_percentage)
            discount_percentage = try values.decodeIfPresent(String.self, forKey: .discount_percentage)
            additional_cost_discount_amount = try values.decodeIfPresent(String.self, forKey: .additional_cost_discount_amount)
            discount_amount = try values.decodeIfPresent(String.self, forKey: .discount_amount)
            vat_amount = try values.decodeIfPresent(String.self, forKey: .vat_amount)
            total_amount = try values.decodeIfPresent(String.self, forKey: .total_amount)
            order_number = try values.decodeIfPresent(Int.self, forKey: .order_number)
            service_time = try values.decodeIfPresent(String.self, forKey: .service_time)
            address_title = try values.decodeIfPresent(String.self, forKey: .address_title)
            payment_method = try values.decodeIfPresent(String.self, forKey: .payment_method)
            order_total = try values.decodeIfPresent(String.self, forKey: .order_total)
        }

    }

struct addInvoiceDataToSend{
    var additionalAmount = "0"
    var VAT = "0"
    var couponData = "0"
    var walletBalance = "0"
    var totalAmount = "0"
}


