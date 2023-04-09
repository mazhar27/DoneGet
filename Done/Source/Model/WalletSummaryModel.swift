//
//  WalletSummaryModel.swift
//  Done
//
//  Created by Mazhar Hussain on 15/08/2022.
//

import Foundation
struct WalletSummaryModel : Codable {
    let status_code : Int?
    let message : String?
    let data : WalletData?

    enum CodingKeys: String, CodingKey {

        case status_code = "status_code"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(WalletData.self, forKey: .data)
    }

}
struct WalletData : Codable {
    let wallet_id : Int?
    let user_id : Int?
    let balance : Double?
    let created_at : String?
    let updated_at : String?
    let transactions_count : Int?
    let total_spent : Double?
    let transactions : [WalletTransactions]?

    enum CodingKeys: String, CodingKey {

        case wallet_id = "wallet_id"
        case user_id = "user_id"
        case balance = "balance"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case transactions_count = "transactions_count"
        case total_spent = "total_spent"
        case transactions = "transactions"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        wallet_id = try values.decodeIfPresent(Int.self, forKey: .wallet_id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        balance = try values.decodeIfPresent(Double.self, forKey: .balance)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        transactions_count = try values.decodeIfPresent(Int.self, forKey: .transactions_count)
        total_spent = try values.decodeIfPresent(Double.self, forKey: .total_spent)
        transactions = try values.decodeIfPresent([WalletTransactions].self, forKey: .transactions)
    }

}
struct WalletTransactions : Codable {
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
        order_id = try values.decodeIfPresent(Int?.self, forKey: .order_id) ?? 0
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


