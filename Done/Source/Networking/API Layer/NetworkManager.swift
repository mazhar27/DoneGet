//
//  NetworkManager.swift
//  Done
//
//  Created by Mazhar Hussain on 6/19/22.
//

import Foundation
import Alamofire
import Combine
import UIKit
import Localize_Swift
import SVProgressHUD


var appStoreURL = ""

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}
final class NetworkManager: NetworkServiceType {
    var request: Alamofire.Request?
    let retryLimit = 1
    fileprivate var isReachable = false
    static let shared = NetworkManager()
    private var manager = NetworkReachabilityManager(host:"www.apple.com")
    private init() {}
    
    //MARK: - startMonitoring
    func startMonitoring() {
        self.manager?.startListening(onQueue: DispatchQueue.main,
                                     onUpdatePerforming: { (networkStatus) in
            if networkStatus == .reachable(.cellular) ||
                networkStatus == .reachable(.ethernetOrWiFi) {
                self.isReachable = true
            } else {
                self.isReachable = false
            }
            
        })
    }
    
    func isConnected() -> Bool{
        self.isReachable
    }
    
    
    // Request with sub type
    func request<T: Codable>(url: URLRequestConvertible, showLoader: Bool = true) -> Future<BaseModel<T>, NetworkError> {
        
        if !Connectivity.isConnectedToInternet {
            print("Not Connected")
            return Future<BaseModel<T>, NetworkError> { promise in
                promise(.failure(NetworkError.noInternet))
            }
        }
        
//        if showLoader {SVProgressHUD.show()}
        return Future<BaseModel<T>, NetworkError> { promise in
            
            AF.request(url).decodable(showLoader, url.urlRequest?.url?.path ?? "") { data in
                promise(.success(data))
                
            } failure: { (error) in
                promise(.failure(error!))
                
            }
        }
    }
    func requestMultipart<T: Codable>(url: String, images: [UIImage]?, params: [String:Any], filename: String,showLoader: Bool = true,url1: URLRequestConvertible) -> Future<BaseModel<T>, NetworkError> {
        let myURL = Constants.API.baseURL + url
        // Check if internet connected
        if !isConnected() {
            return Future<BaseModel<T>, NetworkError> { promise in
                promise(.failure(NetworkError.noInternet))
            }
        }
        
        
        if showLoader {SVProgressHUD.show()}
        return Future<BaseModel<T>, NetworkError> { promise in
            //Set Your URL
            let api_url = myURL
            guard let url = URL(string: api_url) else {
                return
            }
            
            var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            // Now Execute
            AF.upload(multipartFormData: { multipartFormData in
                //uploading images
                if let imgs = images {
                    for i in 0..<imgs.count {
                        guard let imgData = imgs[i].jpegData(compressionQuality: 0.4) else {continue}
                        multipartFormData.append(imgData, withName: filename, fileName: "image-123.png", mimeType: "image/jpeg")
                    }
                }
                //uploading params
                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                
            }, with: url1)
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                print("Upload Progress: \(progress.fractionCompleted)")
            }).decodable(showLoader, "") { data in
                promise(.success(data))
                
            } failure: { (error) in
                promise(.failure(error!))
                
            }
        }
    }
    func getHeaders() -> HTTPHeaders {
        var headers: HTTPHeaders =
        [
            "device-type": "iOS",
            "app-version": Constants.Version.shortVersion,
            "lang" : Localize.currentLanguage(),
            "accept": "application/json"
        ]
        
        if let token = KeychainHelper.standard.read(Constants.Strings.token, Token.self) {
            if let access_token = token.accessToken, let type = token.tokenType {
                headers["Authorization"] = type+" "+access_token
            }
        }
        return headers
    }
    
    func requestwithoutConvertible<T: Codable>(url: String, params: [String:Any],method: HTTPMethod, showLoader: Bool = true) -> Future<BaseModel<T>, NetworkError> {
        let myURL = Constants.API.baseURL + url
        var encoding : ParameterEncoding = URLEncoding.default
        if method == .post || method == .delete {
            encoding = JSONEncoding.default
        }
        
        // Check if internet connected
        
        if !isConnected() {
            return Future<BaseModel<T>, NetworkError> { promise in
                promise(.failure(NetworkError.noInternet))
            }
        }
        
        
        if showLoader {SVProgressHUD.show()}
        return Future<BaseModel<T>, NetworkError> { promise in
            // Now Execute
            AF.request(URL(string: myURL)!, method: method, parameters: params, encoding: encoding, headers: self.getHeaders() ).decodable(showLoader, url) { data in
                promise(.success(data))
                
            } failure: { (error) in
                promise(.failure(error!))
            }
           
        }
    }
    
    
    
    
    // Request without sub type
    func netWorkRequest<T: Codable>(url: URLRequestConvertible, showLoader: Bool = true) -> Future<T, NetworkError>{
        // Check if internet connected
        if !isConnected() {
            return Future<T, NetworkError> { promise in
                promise(.failure(NetworkError.noInternet))
            }
        }
        if showLoader {SVProgressHUD.show()}
        return Future<T, NetworkError> { promise in
            AF.request(url).decodableWithOutSubType(showLoader) { data in
                promise(.success(data))
            } failure: { (error) in
                promise(.failure(error!))
            }
        }
    }
   
    
    
}

extension Alamofire.DataRequest {
    @discardableResult
    func decodable<T: Codable>(_ showLoader: Bool, _ urlEndpoint: String,success: @escaping (BaseModel<T>) -> Swift.Void,
                               failure: @escaping (NetworkError?) -> Swift.Void) -> Self {
        response(completionHandler: { response in
            
            if showLoader{ DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }}
            print(urlEndpoint)
            
            guard let httpResponse = response.response as HTTPURLResponse? else {
                failure(NetworkError.invalidResponse)
                return
            }
            if httpResponse.statusCode == 407 {
                Utilities.shared.showVersionUpdateAlert(message:"update your app bro")
            }
            if urlEndpoint.containsValue("apply-coupon") && httpResponse.statusCode == 422 {
                if let data = response.data {
                    do{
                        let result = try JSONDecoder().decode(BaseModel<T>.self, from: data)
                        print("success")
                        
                        success(result)
                    }catch let error{
                        failure(NetworkError.jsonDecodingError(error:error.localizedDescription))
                    }
                }
            }
            guard 200..<300 ~= httpResponse.statusCode else {
                
                if let data = response.data {
                    print("???? --- \(data)")
                    do{
                        
                        let result = try JSONDecoder().decode(APIResponse.self, from: data)
                        if let message = result.message {
                            return failure(NetworkError.responseError(message: message))
                        }
                        
                    }catch let error{
                        print("???? error --- \(data)")

                        return failure(NetworkError.jsonDecodingError(error:error.localizedDescription))
                    }
                }
                return failure(NetworkError.dataLoadingError(statusCode: httpResponse.statusCode))
            }
            
            if let data = response.data {
                do{
                    let result = try JSONDecoder().decode(BaseModel<T>.self, from: data)
                  
                        if result.code == 407 {
                            Utilities.shared.showVersionUpdateAlert(message: result.message ?? "Please update your app")
                        }
                    
                
                    success(result)
                
                }catch let error{
                    
                    failure(NetworkError.jsonDecodingError(error:error.localizedDescription))
                }
            }
            
        })
        return self
    }
    
    @discardableResult
    func decodableWithOutSubType<T: Codable>(_ showLoader: Bool, success: @escaping (T) -> Swift.Void,
                                             failure: @escaping (NetworkError?) -> Swift.Void) -> Self {
        response(completionHandler: { response in
            if showLoader{ DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }}
           
            guard let httpResponse = response.response as HTTPURLResponse? else {
                failure(NetworkError.invalidResponse)
                return
            }
           
            guard 200..<300 ~= httpResponse.statusCode else {
                if let data = response.data {
                    do{
                        let result = try JSONDecoder().decode(APIResponse.self, from: data)
                        
                        if let message = result.message {
                            return failure(NetworkError.responseError(message: message))
                        }
                        
                    }catch let error{
                        return failure(NetworkError.jsonDecodingError(error:error.localizedDescription))
                    }
                }
                return failure(NetworkError.dataLoadingError(statusCode: httpResponse.statusCode))
            }
            if let data = response.data {
                do{
                    let result = try JSONDecoder().decode(T.self, from: data)
                   
                        if let result1 = result as? APIResponse{
                            if result1.code == 407 {
                                Utilities.shared.showVersionUpdateAlert(message: result1.message ?? "Please update your app")
                            }
                        }
                    
//
                    success(result)
                }catch let error{
                    failure(NetworkError.jsonDecodingError(error:error.localizedDescription))
                }
            }
            
        })
        return self
    }
}


extension NetworkManager: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        let request = urlRequest
        //        guard let token = UserDefaultsManager.shared.getToken() else {
        //            completion(.success(urlRequest))
        //            return
        //        }
        //        let bearerToken = "Bearer \(token)"
        //        request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        //        print("\nadapted; token added to the header field is: \(bearerToken)\n")
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        guard request.retryCount < retryLimit else {
            completion(.doNotRetry)
            return
        }
        print("\nretried; retry count: \(request.retryCount)\n")
        refreshToken { isSuccess in
            isSuccess ? completion(.retry) : completion(.doNotRetry)
        }
    }
    
    func refreshToken(completion: @escaping (_ isSuccess: Bool) -> Void) {
        
        let parameters = ["grant_type": "client_credentials"]
        AF.request("authorize", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if let data = response.data, let token = (try? JSONSerialization.jsonObject(with: data, options: [])
                                                      as? [String: Any])?["access_token"] as? String {
                //                UserDefaultsManager.shared.setToken(token: token)
                print("\nRefresh token completed successfully. New token is: \(token)\n")
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    
}



