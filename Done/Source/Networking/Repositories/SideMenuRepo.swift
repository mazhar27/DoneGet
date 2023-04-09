//
//  SideMenuRepo.swift
//  Done
//
//  Created by Mazhar Hussain on 22/08/2022.
//

import Foundation
import Combine

class SideMenuRepo{
  
    // Get Wallet Summary
    // Validate Coupon
    static func getCustomerOrder(status:String,page: String) -> Future<BaseModel<CustomerOrderData>,NetworkError> {
        let url = "customer-orders/" + status + "?page=" + page
        return NetworkManager.shared.requestwithoutConvertible(url: url, params: [:], method: .get, showLoader: true)
    }
//    get wallet summary
    static func getCustomerWalletSummary() -> Future<BaseModel<WalletData>,NetworkError> {
        let params:[String: Any] = ["": ""]
       
        return NetworkManager.shared.request(url: Router.walletSummary(parameters: params))
    }
    //    get transactions summary
        static func getCustomerTransactionsSummary() -> Future<BaseModel<WalletTransactionsData>,NetworkError> {
            let params:[String: Any] = ["": ""]
           
            return NetworkManager.shared.request(url: Router.transactionsSummary(parameters: params))
        }
    
    //    get additional invoice summary
        static func getCustomerAddInvoice() -> Future<BaseModel<[AdditionalInvoiceData]>,NetworkError> {
            let params:[String: Any] = ["": ""]
           
            return NetworkManager.shared.request(url: Router.additionalInvoice(parameters: params))
        }
    
    //  Change additional invoice status
    static func changeAdditionalInvoiceStatus(status: String, addCostId: String, transId: String) -> Future<BaseModel<APIResponse>,NetworkError> {
        let params:[String: Any] = ["status": status,"transaction_id" : transId,"additional_cost_id": addCostId]
           
            return NetworkManager.shared.request(url: Router.additionalInvoiceStatus(parameters: params))
        }
    
    //    get notifications summary
    static func getNotificationsSummary(page: String) -> Future<NotificationsModel,NetworkError> {
            let params:[String: Any] = ["page": page]
            return NetworkManager.shared.netWorkRequest(url: Router.notificationsDetails(parameters: params))
        }
    
}
