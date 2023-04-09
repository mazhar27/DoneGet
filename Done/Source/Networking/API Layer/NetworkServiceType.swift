//
//  NetworkServiceType.swift
//  Done
//
//  Created by Mazhar Hussain on 6/20/22.
//

import Foundation
import Alamofire
import Combine

enum RequestType: String {
    case get, post, put, delete
}

enum NetworkError : Error {
    case invalidRequest
    case invalidResponse
    case dataLoadingError(statusCode: Int)
    case jsonDecodingError(error: String)
    case responseError(message: String)
    case noInternet
    var errorDescription: String? {
        switch self {
        case .invalidRequest,.invalidResponse,.dataLoadingError(_):
            return Constants.Strings.RequestError
        case .jsonDecodingError(let error):
            return error
        case .responseError(let message):
            return message
        case .noInternet:
            return Constants.Strings.networkError
        }
    }
}

protocol NetworkServiceType{
    
    func netWorkRequest<T: Codable>(url: URLRequestConvertible, showLoader: Bool) -> Future<T, NetworkError>
    func request<T: Codable>(url: URLRequestConvertible, showLoader: Bool) -> Future<BaseModel<T>, NetworkError>
}
