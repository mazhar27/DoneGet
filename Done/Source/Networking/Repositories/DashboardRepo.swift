//
//  DashboardRepo.swift
//  Done
//
//  Created by Mazhar Hussain on 29/06/2022.
//

import Foundation
import Combine
import UIKit

class DashboardRepo {
    
    // Get customer addresses
    static func getCustomerAddresses() -> Future<BaseModel<[CustomerAddress]>,NetworkError> {
        
        return NetworkManager.shared.request(url: Router.customerAddresses(parameters: [:]))
    }
    static func getBannerAndPromotions() -> Future<BaseModel<[BanerData]>,NetworkError> {
        
        return NetworkManager.shared.request(url: Router.bannersAndPromotions(parameters: [:]))
    }
    // Get Settings
    static func getSiteSetting() -> Future<BaseModel<SettingData>,NetworkError> {
        
        return NetworkManager.shared.request(url: Router.siteSetting(parameters: [:]))
    }
    
    // Save customer addresses
    static func saveCustomerAddresses(model: CustomerAddress) -> Future<BaseModel<APIResponse>,NetworkError> {
        
        let params:[String: Any] = ["latitude": model.latitude ?? "0.0",
                                    "longitude":model.longitude ?? "0.0",
                                    "address_name":model.addressName ?? "",
                                    "address_title":model.addressTitle ?? "",
                                    "address_description":model.addressDetail ?? "",
                                    "street":model.street ?? "",
                                    "floor":model.floor ?? "",
                                    "provider_note":model.providerNote ?? ""]
        
        print("params: \(params)")
        return NetworkManager.shared.request(url: Router.customerSaveAddress(parameters: params))
    }
    
    // Update customer addresses
    static func updateCustomerAddresses(model: CustomerAddress) -> Future<BaseModel<APIResponse>,NetworkError> {
        
        let params:[String: Any] = ["latitude": model.latitude ?? "0.0",
                                    "longitude":model.longitude ?? "0.0",
                                    "address_name":model.addressName ?? "",
                                    "address_title":model.addressTitle ?? "",
                                    "address_description":model.addressDetail ?? "",
                                    "street":model.street ?? "",
                                    "floor":model.floor ?? "",
                                    "provider_note":model.providerNote ?? "",
                                    "address_id": model.addressId ?? 0]
        
        print("params: \(params)")
        return NetworkManager.shared.request(url: Router.customerUpdateAddress(parameters: params))
    }
    
    //Delete address
    static func deleteCustomerAddresses(addressID: String) -> Future<APIResponse,NetworkError> {
        
        let params:[String: Any] = ["address_id": addressID]
        
        print("Login params: \(params)")
        return NetworkManager.shared.netWorkRequest(url: Router.deleteCustomerAddress(parameters: params))
    }
    //Delete Account
    static func deleteCustomerAccount(pin: String) -> Future<APIResponse,NetworkError> {
        
        let params:[String: Any] = ["pin": pin]
        
        print("Login params: \(params)")
        return NetworkManager.shared.netWorkRequest(url: Router.deleteCustomerAccount(parameters: params))
    }
    
    // Validate Coupon
    static func deleteCustomerAccountNew(param: [String: Any]) -> Future<BaseModel<APIResponse>,NetworkError> {
        
        let params = param
        print("params: \(params)")
        return NetworkManager.shared.requestwithoutConvertible(url: "delete-customer", params: param, method: .delete, showLoader: true)
    }
    
    // Get All Services
    
    static func getAllServices() -> Future<BaseModel<ServicesDataModel>,NetworkError> {
        
        return NetworkManager.shared.request(url: Router.allServices(parameters: [:]))
    }
    
    // Get Services Categories
    
    static func getServicesCategories(serviceId: String) -> Future<BaseModel<ServiceCategoriesDataModel>,NetworkError> {
        let params:[String: Any] = ["service_id": serviceId]
        return NetworkManager.shared.request(url: Router.serviceCategories(parameters: params))
    }
    
    // Get Services Form Data
    
    static func getServicesDetailForm(serviceId: String, categoryID : String) -> Future<BaseModel<FormData>,NetworkError> {
        let params:[String: Any] = ["service_id": serviceId,"category_id" : categoryID]
        return NetworkManager.shared.request(url: Router.serviceDetailForm(parameters: params))
    }
    
    //    Upload Images
    static func uploadImages(images: [UIImage]?) -> Future<BaseModel<[String]>,NetworkError> {
        let params:[String: Any] = [:]
        return NetworkManager.shared.requestMultipart(url: "upload-image", images: images, params: params, filename: "file[]", showLoader: true, url1: Router.uploadImages(parameters: params))
    }
    // Get Providers List Data
    
    static func getProvidersList(model: ProvidersListParameterModel) -> Future<BaseModel<ProvidersListData>,NetworkError> {
        let params:[String: Any] = ["date": model.date,"sort_price_dsc" : model.sort_price_dsc,"sort_price_asc":model.sort_price_asc,"sort_rating":"0.0","latitude":model.latitude,"service_type":model.service_type,"category_id":model.category_id,"options":model.options,"time":model.time,"longitude":model.longitude]
        return NetworkManager.shared.request(url: Router.providersList(parameters: params),showLoader: true)
    }
    //NO Provider Lead
    static func noProviderLead(service_time : String, service_date: String,service_id:String,category_id:String,address: String,option_id: [Int]) -> Future<BaseModel<APIResponseGeneric>,NetworkError> {
        let params = ["service_time": service_time,"service_date":service_date,"service_id":service_id,"category_id":category_id,"address":address,"option_id":option_id] as [String : Any]
        return NetworkManager.shared.netWorkRequest(url: Router.noProvider(parameters: params))
    }
    // Get Providers Time Slots
    static func getProviderTimeSlots(date: String, service_id: String,provider_id: String) -> Future<BaseModel<TimeSlotsData>,NetworkError> {
        let params:[String: Any] = ["date": date,"service_id": service_id,"provider_id": provider_id]
        return NetworkManager.shared.request(url: Router.providerTimeSlots(parameters: params))
    }
    
    // Get User Profile
    static func getUserProfileData() -> Future<BaseModel<ProfileData>,NetworkError> {
        let params:[String: Any] = [:]
        return NetworkManager.shared.request(url: Router.customerProfile(parameters: params))
    }
    // Update User Profile
    static func updateCustomerProfile(key: String, value: String) -> Future<BaseModel<APIResponse>,NetworkError> {
        let params:[String: Any] = ["key": key, "value": value]
        return NetworkManager.shared.request(url: Router.updateProfile(parameters: params))
    }
    // Update User Profile Picture
    static func updateCustomerProfilePic(key: String,images:[UIImage]) -> Future<BaseModel<APIResponse>,NetworkError> {
        let params:[String: Any] = ["key": key]
        return NetworkManager.shared.requestMultipart(url: "update-profile", images: images, params: params, filename: "value", showLoader: true, url1: Router.updateProfile(parameters: params))
    }
    
}


