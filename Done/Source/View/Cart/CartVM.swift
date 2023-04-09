//
//  CartVM.swift
//  Done
//
//  Created by Mazhar Hussain on 21/06/2022.
//

import Foundation
import Combine

class CartVM {
   
    var tagsDataArray = [String]()
    var discountPriceDataArray = [String]()
    private var cancellables = Set<AnyCancellable>()
    let couponResult = PassthroughSubject<CouponData, Error>()
    @Published private(set) var message = [String]()
    @Published private(set) var state = State.idle
    var servicesArray = [NSMutableDictionary]()
    var couponData = [String]()
    
    
    func getCouponRequestParams(firstTime: Bool, coupons: [String]) -> NSMutableDictionary {
        let mainDictionary = NSMutableDictionary()
        if let cart = UserDefaults.cartData{
       let serArray = servicesArrayy(dataCart: cart)
        mainDictionary.setValue(serArray, forKey: "services")
        }
        print(dictionaryToJsonString(dictionary: mainDictionary))
     
        if UserDefaults.userType == .customer{
        mainDictionary.setValue(UserDefaults.LoginUser?.id, forKey: "customer_id")
        }else{
            mainDictionary.setValue("0", forKey: "customer_id")
       }
        if firstTime{
            mainDictionary.setValue(couponData, forKey: "coupon_codes")
        }else{
            mainDictionary.setValue(coupons, forKey: "coupon_codes")
        }
      
      
       
        return mainDictionary
    
    }
   
    func servicesArrayy(dataCart: [Services]) -> [NSMutableDictionary] {
       
        servicesArray = []
        for (_, item) in dataCart.enumerated() {
         //   let optionIds = selectedOptionIDs[item.options]
            let cartItem = NSMutableDictionary()
            cartItem.setValue(dataCart[0].address_latitude, forKey: "address_latitude")
            cartItem.setValue(dataCart[0].address_longitude, forKey: "address_longitude")
            cartItem.setValue(dataCart[0].address_title, forKey: "address_title")
           
            cartItem.setValue(item.date_time, forKey: "date_time")
          cartItem.setValue(item.service_type, forKey: "service_type") //1 home 2 COD
            cartItem.setValue(item.provider_id, forKey: "provider_id")
            cartItem.setValue(item.category_id, forKey: "category_id")
            cartItem.setValue(item.service_id, forKey: "service_id")
            cartItem.setValue(item.coupon_id, forKey: "coupon_id")
            cartItem.setValue(item.coupon_code, forKey: "coupon_code")
            cartItem.setValue(item.service_instructions, forKey: "service_instructions") //desc box
            cartItem.setValue(item.service_price, forKey: "service_price")
         cartItem.setValue(item.slot_id, forKey: "slot_id")
           cartItem.setValue(item.option_id, forKey: "option_id")
           cartItem.setValue(item.images, forKey: "images")
            cartItem.setValue(item.categoryName, forKey: "categoryName")
            cartItem.setValue(item.serviceName, forKey: "serviceName")
            cartItem.setValue(item.serviceImage, forKey: "serviceImage")
            if item.coupon_code == ""{
                couponData.append("0")
            }else{
            couponData.append(item.coupon_code ?? "0")
            }
         servicesArray.append(cartItem)
        }
        UserDefaults.couponCodes = couponData
        return servicesArray
    }
   
    func getCouponResult(firstTime: Bool,couponListEmpty:Bool = false, coupons : [String]) {
        self.state = .loading
        let params = getCouponRequestParams(firstTime: firstTime, coupons: coupons)
        CartRepo.validateCoupon(param: params as! [String : Any])
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
//                    self?.state = .error(error.localizedDescription)
                    self?.couponResult.send(completion: .failure(error))
                    self?.state = .error(error.errorDescription ?? "")
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
               
                if let coupon = result.data {
                    print(result)
                    if !firstTime && !couponListEmpty{
                        var errorsCodes = ""
                    if let couponError = coupon.coupon_error{
//                        self?.message = couponError[0].coupon_code ?? ""
                        for item in couponError{
                            if item.is_expired == 1{
                                let details = (item.coupon_code ?? "") + " : " + "Expired".localized() + " \n "
                                errorsCodes = errorsCodes + details
                            }
                            if item.not_found == 1{
                                let details = (item.coupon_code ?? "") + " : " + "not found".localized() + " \n "
                                errorsCodes = errorsCodes + details
                            }
                        }
                        let titlemessage = result.message ?? ""
                        self?.message = [errorsCodes, titlemessage]
                       
                    }else{
                        self?.state = .loaded(result.message ?? "")
                    }
                     
                }
                    self?.couponResult.send(coupon)
                }
//                self?.state = .loaded(result.message ?? "")
            }).store(in: &cancellables)
    }
    
    
}

//MARK: - JSON String
func dictionaryToJsonString(dictionary: NSMutableDictionary) -> String {
    var jsonString = ""
    if let theJSONData = try? JSONSerialization.data(
        withJSONObject: dictionary,
        options: []) {
        let theJSONText = String(data: theJSONData,
                                 encoding: .utf8)
        jsonString = theJSONText ?? ""
    }
    return jsonString
}
