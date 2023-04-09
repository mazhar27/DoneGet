//
//  Router.swift
//  Done
//
//  Created by Mazhar Hussain on 6/20/22.
//

import Foundation
import Alamofire


typealias Headers = [String: String]

enum Router: URLRequestConvertible {
    
    case login(parameters: Parameters)
    case register(parameters: Parameters)
    case verifyOTP(parameters: Parameters)
    case verifyOTPUpdateProfile(parameters: Parameters)
    case resendOTP(parameters: Parameters)
    case basicInfo(parameters: Parameters)
    case createPin(parameters: Parameters)
    case logOut(parameters: Parameters)
    case customerAddresses(parameters: Parameters)
    case bannersAndPromotions(parameters: Parameters)
    case siteSetting(parameters: Parameters)
    case customerSaveAddress(parameters: Parameters)
    case customerUpdateAddress(parameters: Parameters)
    case deleteCustomerAddress(parameters: Parameters)
    case deleteCustomerAccount(parameters: Parameters)
    case allServices(parameters: Parameters)
    case serviceCategories(parameters: Parameters)
    case serviceDetailForm(parameters: Parameters)
    case providersList(parameters: Parameters)
    case providerTimeSlots(parameters: Parameters)
    case uploadImages(parameters: Parameters)
    case customerProfile(parameters: Parameters)
    case updateProfile(parameters: Parameters)
    case walletSummary(parameters: Parameters)
    case transactionsSummary(parameters: Parameters)
    case validateCoupon(parameters: Parameters)
    case bankHostedURL(parameters: Parameters)
    case refreshToken(parameters: Parameters)
    case topUpWallet(parameters: Parameters)
    case additionalInvoice(parameters: Parameters)
    case additionalInvoiceStatus(parameters: Parameters)
    case notificationsDetails(parameters: Parameters)
    case providerDashboardStats(parameters: Parameters)
    case providerJobs(parameters: Parameters)
    case providerProfile(parameters:Parameters)
    case changeJobStatus(parameters: Parameters)
    case noProvider(parameters: Parameters)
    case setAdditionalInvoice(parameters: Parameters)
    case timeSlotBooking(parameters: Parameters)
    case changeTimeSlotStatus(parameters: Parameters)
    case deleteProviderAccount(parameters: Parameters)
    var method: HTTPMethod {
        switch self {
        case .login, .register, .verifyOTP, .bannersAndPromotions ,.resendOTP, .basicInfo, .createPin,
                .logOut,.customerSaveAddress,.deleteCustomerAddress,
                .customerUpdateAddress, .refreshToken, .allServices, .serviceCategories,.serviceDetailForm,.providersList,.providerTimeSlots,.uploadImages,.updateProfile,.verifyOTPUpdateProfile,.validateCoupon,.bankHostedURL,.topUpWallet,.additionalInvoiceStatus,.changeJobStatus,.setAdditionalInvoice,.timeSlotBooking,.changeTimeSlotStatus,.deleteProviderAccount,.noProvider:
            return .post
        case .customerAddresses , .customerProfile,.walletSummary,.transactionsSummary,.additionalInvoice,.notificationsDetails,.providerDashboardStats,.providerJobs,.providerProfile,.siteSetting:
            return .get
        case .deleteCustomerAccount:
            return .delete
            
        }
    }
    
    var path: String {
        switch self {
        case .siteSetting:
            return "get-site-setting"
        case .login:
            return "login"
        case .register:
            return "register"
        case .verifyOTP:
            return "verify-otp"
        case .resendOTP:
            return "resend-otp"
        case .basicInfo:
            return "basic-info"
        case .createPin:
            return "create-pin"
        case .logOut:
            return "logout"
        case .customerAddresses:
            return "get-customer-addresses"
        case .bannersAndPromotions:
            return "get-promotional-bannners"
        case .customerSaveAddress:
            return "save-address"
        case .deleteCustomerAddress:
            return "delete-address"
        case .customerUpdateAddress:
            return "update-address"
        case .deleteCustomerAccount:
            return "delete-customer"
        case .allServices:
            return "get-all-services-list"
        case .serviceCategories:
            return "get-categories"
        case .serviceDetailForm:
            return "get-sevice-detail-form"
        case .providersList:
            return "get-providers"
        case .providerTimeSlots:
            return "get-time-slot"
        case .uploadImages:
            return "upload-image"
        case .customerProfile:
            return "profile"
        case .updateProfile:
            return "update-profile"
        case .verifyOTPUpdateProfile:
            return "otp-verify"
        case .walletSummary:
            return "get-wallet-summary"
        case .validateCoupon:
            return "apply-coupon"
        case .bankHostedURL:
            return "arb/bankhosted-url"
        case .transactionsSummary:
            return "wallet-transactions"
        case .topUpWallet:
            return "topup-wallet"
        case .additionalInvoice:
            return "get-additional-invoices"
        case .additionalInvoiceStatus:
            return "change-additional-cost-status"
        case .notificationsDetails:
            return "get-notifications"
       case .providerDashboardStats:
            return "dashboard-data"
        case .providerJobs:
            return "provider-jobs"
        case .changeJobStatus:
            return "set-job-status"
        case .setAdditionalInvoice:
            return "set-additional-invoice"
        case .timeSlotBooking:
            return "provider-slots"
        case .changeTimeSlotStatus:
            return "change-slot-status"
        case .refreshToken:
            return "refresh"
        case .providerProfile:
            return "provider-profile"
        case .deleteProviderAccount:
            return "delete-provider"
        case .noProvider:
            return "add-lead"
        }
    }
    
    func getHeaders() -> HTTPHeaders {
        var headers: HTTPHeaders =
        [
            "device-type": "iOS",
            "app-version": Constants.Version.shortVersion,
            "lang" : "Localize.currentLanguage()",
            "accept": "application/json"
        ]
        
        if let token = KeychainHelper.standard.read(Constants.Strings.token, Token.self) {
            if let access_token = token.accessToken, let type = token.tokenType {
                headers["Authorization"] = type+" "+access_token
            }
        }
        return headers
    }
    
    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        
        let url = try Constants.API.baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = getHeaders()
        
        switch self {
        case .login(let parameters),
                .siteSetting(let parameters),
                .register(let parameters),
                .verifyOTP(let parameters),
                .resendOTP(let parameters),
                .basicInfo(let parameters),
                .createPin(let parameters),
                .logOut(let parameters),
                .customerAddresses(let parameters),
                .bannersAndPromotions(parameters: let parameters),
                .customerSaveAddress(let parameters),
                .deleteCustomerAddress(let parameters),
                .customerUpdateAddress(let parameters),
                .deleteCustomerAccount(let parameters),
                .allServices(let parameters),
                .serviceCategories(let parameters),
                .serviceDetailForm(let parameters),
                .refreshToken(let parameters),
                .providersList(let parameters),
                .providerTimeSlots(let parameters),
                .customerProfile(let parameters),
                .updateProfile(let parameters),
                .uploadImages(let parameters),
                .verifyOTPUpdateProfile(let parameters),
                .walletSummary(let parameters),
                .validateCoupon(let parameters),
                .bankHostedURL(let parameters),
                .transactionsSummary(let parameters),
                .topUpWallet(let parameters),
                .additionalInvoice(let parameters),
                .additionalInvoiceStatus(let parameters),
                .notificationsDetails(let parameters),
                .providerDashboardStats(let parameters),
                .providerJobs(let parameters),
                .providerProfile(let parameters),
                .changeJobStatus(let parameters),
                .setAdditionalInvoice(let parameters),
                .timeSlotBooking(let parameters),
                .changeTimeSlotStatus(let parameters),
                .deleteProviderAccount(let parameters),
                .noProvider(let parameters):
            
            return try URLEncoding.default.encode(urlRequest, with: parameters)
            
        }
    }
}
