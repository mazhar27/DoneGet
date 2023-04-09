//
//  ProvidersDetailsVM.swift
//  Done
//
//  Created by Mazhar Hussain on 17/06/2022.
//

import Foundation
import Combine

class ProvidersDetailsVM {
    
 private var cancellables = Set<AnyCancellable>()
    let providersResult = CurrentValueSubject<[Slots], Error>([])
    
    func getAllProvidersTimeSlots(date: String, serviceID: String, providerID: String) {
        DashboardRepo.getProviderTimeSlots(date: date, service_id: serviceID, provider_id: providerID)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
//                    self?.state = .error(error.localizedDescription)
                    self?.providersResult.send(completion: .failure(error))
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                if let timeslots = result.data?.slots {
                    self?.providersResult.send(timeslots)
                }
//                self?.state = .loaded(result.message ?? "")
            }).store(in: &cancellables)
    }
    func saveCartData(){
       
        var cartdata = Services(address_latitude: SessionModel.shared.location.latitude!, address_longitude: SessionModel.shared.location.longitude!, address_title: SessionModel.shared.location.addressTitle!, images: SessionModel.shared.imagesArray, cart_service_id: 0, category_id: Int(SessionModel.shared.categoryID)!, coupon_code: "", coupon_id: 0, date_time: SessionModel.shared.timeslot_dateTime, option_id: SessionModel.shared.option_id, service_type: Int(SessionModel.shared.serviceType.rawValue)!, answers: [""], provider_id: Int(SessionModel.shared.providerID)!, service_id: Int(SessionModel.shared.subServiceID), service_instructions: "", service_price: SessionModel.shared.servicePrice, slot_id: SessionModel.shared.providerTimeSlotID, discount_percentage: "0", discounted_amount: "", categoryName: SessionModel.shared.categoryName, serviceName: SessionModel.shared.subServiceName, serviceImage: SessionModel.shared.mainServiceImage)
        if var cart = UserDefaults.cartData{
            if let index = SessionModel.shared.cartServiceEditIndex{
                cartdata.coupon_id = SessionModel.shared.couponID
                cartdata.coupon_code = SessionModel.shared.couponCode
                cart[index] = cartdata
                UserDefaults.cartData = cart
            }else{
           cart.append(cartdata)
            UserDefaults.cartData = cart
            }
        }else{
            UserDefaults.cartData = [cartdata]
        }
    }
}
