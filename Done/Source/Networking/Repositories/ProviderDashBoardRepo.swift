//
//  ProviderDashBoardRepo.swift
//  Done
//
//  Created by Mazhar Hussain on 05/09/2022.
//

import Foundation
import Combine

class ProviderDashBoardRepo{
    
    // DahBoard Data
    static func getProviderDashStats() -> Future<BaseModel<ProviderDashboardData>,NetworkError> {
        
        return NetworkManager.shared.request(url: Router.providerDashboardStats(parameters: [:]))
    }
    
    //Provider Jobs Data
    static func getProviderJobsData(status: String, page: String) -> Future<BaseModel<ProviderJobsData>,NetworkError> {
        
        let url = "provider-jobs/" + status + "?page=" + page
        return NetworkManager.shared.requestwithoutConvertible(url: url, params: [:], method: .get, showLoader: true)
    }
    // Job Details
    static func getProviderJobDetails(jobId:String) -> Future<BaseModel<ProviderJobDetailsData>,NetworkError> {
        let url = "job-detail/" + jobId
        return NetworkManager.shared.requestwithoutConvertible(url: url, params: [:], method: .get, showLoader: true)
    }
    
    // Change Provider Job Status Data
    static func changeJobStatus(orderServiceID : String, rejectionReason: String,status:String) -> Future<BaseModel<APIResponseGeneric>,NetworkError> {
        let params = ["order_service_id": orderServiceID,"rejection_reason":rejectionReason,"status":status]
        return NetworkManager.shared.netWorkRequest(url: Router.changeJobStatus(parameters: params))
    }
    
    // Provider Additional Invoice
    static func providerAdditionalInvoice(orderServiceID : String, price: String,remarks:String) -> Future<BaseModel<APIResponseGeneric>,NetworkError> {
        let params = ["order_service_id": orderServiceID,"price":price,"remarks":remarks]
        return NetworkManager.shared.netWorkRequest(url: Router.setAdditionalInvoice(parameters: params))
    }
    
    // Get Providers Time Slots
    static func getProviderSlotsBooking(date: String) -> Future<BaseModel<TimeSlotsData>,NetworkError> {
        let params:[String: Any] = ["date": date]
        return NetworkManager.shared.request(url: Router.timeSlotBooking(parameters: params))
    }
    // Change Providers Time Slots
    static func changeProviderTimeSlot(date: String, slotId: String, status: String) -> Future<APIResponse,NetworkError>  {
        let params:[String: Any] = ["date": date,"slot_id":slotId,"status":status]
        return NetworkManager.shared.netWorkRequest(url: Router.changeTimeSlotStatus(parameters: params))
    }
    
    
}
