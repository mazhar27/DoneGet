//
//  CartData.swift
//  Done
//
//  Created by Mazhar Hussain on 12/08/2022.
//

import Foundation
class Cart: NSObject, Codable {
    var mainServiceName = ""
    var mainServiceID = ""
    var mainServiceImageUrl = ""
    var subServiceName = ""
    var subServiceID = ""
    var subServiceImageUrl = ""
    var serviceType = ServiceType.Home //Home or Collect Return
    var providerName = ""
    var providerID = ""
    var providerDateSelected = ""
    var providerTimeSelected = ""
    var providerTimeSlotID = ""
    var servicePrice = ""
    var isFullyBooked = "0"
    var categoryID = ""
    var categoryName = ""
    var selectedQuestion = [QuestionAnswerHandeling]()
    
    var options : [Int] =  []
    
    init(mainServiceID: String, mainServiceName: String, mainServiceImageUrl: String, subServiceID: String, subServiceName: String, subServiceImageUrl: String, serviceType: ServiceType, providerName: String, providerID: String, providerDateSelected: String, providerTimeSelected: String, servicePrice: String, cartFormData: CartFormData, providerTimeSlotID: String, isFullyBooked: String, categoryID: String, categoryName: String ,options : [Int]) {
        self.mainServiceID = mainServiceID
        self.mainServiceName = mainServiceName
        self.mainServiceImageUrl = mainServiceImageUrl
        self.subServiceID = subServiceID
        self.subServiceName = subServiceName
        self.subServiceImageUrl = subServiceImageUrl
        self.serviceType = serviceType
        self.providerName = providerName
        self.providerID = providerID
       self.servicePrice = servicePrice
        self.providerDateSelected = providerDateSelected
        self.providerTimeSelected = providerTimeSelected
        self.providerTimeSlotID = providerTimeSlotID
        self.isFullyBooked = isFullyBooked
        self.categoryID = categoryID
        self.categoryName = categoryName
        self.options = options
    }
}
