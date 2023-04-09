//
//  CheckOutViewModel.swift
//  Done
//
//  Created by Mazhar Hussain on 17/08/2022.
//

import Foundation
import Combine

class CheckOutViewModel {
    
    private var cancellables = Set<AnyCancellable>()
    let orderResult = PassthroughSubject<OrderDetailsData, Error>()
    var servicesArray = [NSMutableDictionary]()
    var couponData = [String]()
    
    
    func placeOrder(extraPayment: Extras,orderType: String) {
        let params = getorderPlaceParams(extraPayment: extraPayment, orderType: orderType)
         
         CartRepo.PlaceOrder(param: params as! [String : Any])
             .sink(receiveCompletion: { [weak self] result in
                 switch result {
                 case .failure(let error):
 //                    self?.state = .error(error.localizedDescription)
                     self?.orderResult.send(completion: .failure(error))
                     break
                 case .finished:
                     break
                 }
             }, receiveValue: { [weak self] result in
                
                 if let coupon = result.data {
                     print(result)
                     self?.orderResult.send(coupon)
                 }
 //                self?.state = .loaded(result.message ?? "")
             }).store(in: &cancellables)
     }
    
    func getorderPlaceParams(extraPayment: Extras, orderType: String) -> NSMutableDictionary {
        let mainDictionary = NSMutableDictionary()
        if let cart = UserDefaults.cartData{
       let serArray = servicesArrayy(dataCart: cart)
        mainDictionary.setValue(serArray, forKey: "services")
        }
        print(dictionaryToJsonString(dictionary: mainDictionary))
    
        let extra = orderPlaceExtra(item: extraPayment, orderType: orderType)
        mainDictionary.setValue(extra, forKey: "extras")
        
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
            if item.coupon_code != ""{
                couponData.append(item.coupon_code ?? "")
            }
           
            couponData = Array(Set(couponData))
            
         servicesArray.append(cartItem)
        }
        return servicesArray
    }
    func orderPlaceExtra( item: Extras, orderType: String) -> NSMutableDictionary {
        let extraItem = NSMutableDictionary()
        
        extraItem.setValue(item.services_total, forKey: "base_amount")
        extraItem.setValue(couponData, forKey: "coupon_codes")
        extraItem.setValue(UserDefaults.LoginUser?.id, forKey: "customer_id")
        extraItem.setValue(item.discount_amount, forKey: "discount_amount")
        extraItem.setValue("0", forKey: "order_discount_percentage")
        extraItem.setValue("", forKey: "order_instructions")
        extraItem.setValue(orderType, forKey: "order_type")
        extraItem.setValue(item.discounted_total, forKey: "total_amount")
        extraItem.setValue("", forKey: "transaction_id")
        extraItem.setValue(item.vat_amount, forKey: "vat_amount")
        extraItem.setValue(item.vat_percentage, forKey: "vat_percentage")
        if couponData.count == 0{
            extraItem.setValue([String](), forKey: "coupon_codes")
        }
      return extraItem
    }
     
     
 
}
