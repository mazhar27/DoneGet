//
//  WalletTransactionsModel.swift
//  Done
//
//  Created by Mazhar Hussain on 30/08/2022.
//

import Foundation
struct WalletTransactionsModel : Codable {
    let status_code : Int?
    let message : String?
    let data : WalletTransactionsData?

    enum CodingKeys: String, CodingKey {

        case status_code = "status_code"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(WalletTransactionsData.self, forKey: .data)
    }

}
struct Details : Codable {
    let wallet_transaction_id : Int?
    let wallet_id : Int?
    let order_id : Int?
    let before : Double?
    let transaction_amount : Double?
    let after : Double?
    let transaction_type : String?
    let transaction_detail : String?
    let transaction_id : String?
    let comment : String?
    let is_system_transaction : Int?
    let transaction_date : String?
    let deleted_at : String?
    let created_at : String?
    let updated_at : String?

    enum CodingKeys: String, CodingKey {

        case wallet_transaction_id = "wallet_transaction_id"
        case wallet_id = "wallet_id"
        case order_id = "order_id"
        case before = "before"
        case transaction_amount = "transaction_amount"
        case after = "after"
        case transaction_type = "transaction_type"
        case transaction_detail = "transaction_detail"
        case transaction_id = "transaction_id"
        case comment = "comment"
        case is_system_transaction = "is_system_transaction"
        case transaction_date = "transaction_date"
        case deleted_at = "deleted_at"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        wallet_transaction_id = try values.decodeIfPresent(Int.self, forKey: .wallet_transaction_id)
        wallet_id = try values.decodeIfPresent(Int.self, forKey: .wallet_id)
        order_id = try values.decodeIfPresent(Int.self, forKey: .order_id)
        before = try values.decodeIfPresent(Double.self, forKey: .before)
        transaction_amount = try values.decodeIfPresent(Double.self, forKey: .transaction_amount)
        after = try values.decodeIfPresent(Double.self, forKey: .after)
        transaction_type = try values.decodeIfPresent(String.self, forKey: .transaction_type)
        transaction_detail = try values.decodeIfPresent(String.self, forKey: .transaction_detail)
        transaction_id = try values.decodeIfPresent(String.self, forKey: .transaction_id)
        comment = try values.decodeIfPresent(String.self, forKey: .comment)
        is_system_transaction = try values.decodeIfPresent(Int.self, forKey: .is_system_transaction)
        transaction_date = try values.decodeIfPresent(String.self, forKey: .transaction_date)
        deleted_at = try values.decodeIfPresent(String.self, forKey: .deleted_at)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}
struct Transactions : Codable {
    let date : String?
    let details : [Details]?

    enum CodingKeys: String, CodingKey {

        case date = "date"
        case details = "details"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        details = try values.decodeIfPresent([Details].self, forKey: .details)
    }

}
struct WalletTransactionsData : Codable {
    let transactions : [Transactions]?

    enum CodingKeys: String, CodingKey {

        case transactions = "transactions"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        transactions = try values.decodeIfPresent([Transactions].self, forKey: .transactions)
    }

}

