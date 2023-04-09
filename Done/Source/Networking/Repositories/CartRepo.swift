//
//  CartRepo.swift
//  Done
//
//  Created by Mazhar Hussain on 15/08/2022.
//

import Foundation
import Combine
import UIKit

class CartRepo{
  
    
    // Get Wallet Summary
    static func getWalletSummary() -> Future<BaseModel<WalletData>,NetworkError> {
        
        return NetworkManager.shared.request(url: Router.walletSummary(parameters: [:]))
    }
    // Validate Coupon
    static func validateCoupon(param: [String: Any]) -> Future<BaseModel<CouponData>,NetworkError> {
        
        let params = param
        
        print("params: \(params)")
        return NetworkManager.shared.requestwithoutConvertible(url: "apply-coupon", params: param, method: .post, showLoader: true)
    }
    // Place Order
    static func PlaceOrder(param: [String: Any]) -> Future<BaseModel<OrderDetailsData>,NetworkError> {
        
        let params = param
        
        print("params: \(params)")
        return NetworkManager.shared.requestwithoutConvertible(url: "place-order", params: param, method: .post, showLoader: true)
    }
    // Get Bank Url
    static func getBankHostedURL(param: [String: Any]) -> Future<BaseModel<BankHostedData>,NetworkError> {
        
        return NetworkManager.shared.request(url: Router.bankHostedURL(parameters: param),showLoader: true)
    }
    
    // Top Up Wallet
    static func topUpWallet(param: [String: Any]) -> Future<BaseModel<APIResponse>,NetworkError> {
        
        return NetworkManager.shared.request(url: Router.topUpWallet(parameters: param),showLoader: true)
    }
    
}
