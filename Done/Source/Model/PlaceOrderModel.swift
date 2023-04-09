//
//  PlaceOrderModel.swift
//  Done
//
//  Created by Mazhar Hussain on 19/08/2022.
//

import Foundation

struct OrderDetailsData : Codable {
    let order_details : Order_details?

    enum CodingKeys: String, CodingKey {

        case order_details = "order_details"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        order_details = try values.decodeIfPresent(Order_details.self, forKey: .order_details)
    }

}

struct Order_details : Codable {
    let order_number : String?
    let order_id : Int?
    let amount : String?

    enum CodingKeys: String, CodingKey {

        case order_number = "order_number"
        case order_id = "order_id"
        case amount = "amount"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        order_number = try values.decodeIfPresent(String.self, forKey: .order_number)
        order_id = try values.decodeIfPresent(Int.self, forKey: .order_id)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
    }

}

struct orderPlaceExtraParam {
    var base_amount = ""
    var coupon_codes = [String]()
    var customer_id = ""
   var  discount_amount = ""
   var   order_discount_percentage = ""
   var order_instructions = ""
    var order_type = 0
  var total_amount = ""
      var transaction_id = ""
   var vat_amount = ""
   var vat_percentage = ""
    
}
