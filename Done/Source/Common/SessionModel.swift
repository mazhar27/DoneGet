//
//  SessionModel.swift
//  Done
//
//  Created by Mazhar Hussain on 20/07/2022.
//

import Foundation
class SessionModel {
    private init(){}
    static var shared = SessionModel()
    
    var mainServiceImage = ""
    var mainServiceName = ""
    var mainServiceID = -1
    var subServiceName = ""
    var subServiceImage = ""
    var subServiceID = -1
    var serviceType: ServiceType = .Home //COD or Collect Return
    var providerName = ""
    var providerID = ""
    var providerDateSelected = ""
    var providerTimeSelected = ""
    var providerTimeSlotID = 0
    var servicePrice = ""
    var location = CustomerAddress(addressId: 0, addressTitle: "", addressName: "", addressDetail: "", longitude: "", latitude: "", street: "", floor: "", providerNote: "")
//    var cartFormData = CartFormData()
    var isBookingViewOpened = false
    var filterType: SortByTap = .nearestLocation
    var filterDate = ""
    var filterTime = ""
    var filterRating = ""
    var transactionID = ""
    var merchantTransactionID = ""
    var providerTimeSlotResourcesAvailable = 0
    var categoryID = ""
    var categoryName = ""
    var option_id = [0]
    var cartServiceEditIndex : Int?
    var couponCode = ""
    var couponID = -1
    var serviceDescription = ""
    var imagesArray = [String]()
    var timeslot_dateTime = ""
    
    
   
}
enum ServiceType: String, Codable {
    case Home = "1"
    case CollectReturn = "2"
}

class CartFormData: NSObject, Codable {
    var descriptionService = ""
    var questionAnswers = [CartQuestionAnswer]()
    var referenceImages = [CartReferenceImage]()
    
    override init(){}
    
    init(descriptionService: String, questionAnswers: [CartQuestionAnswer], referenceImages: [CartReferenceImage]) {
        self.descriptionService = descriptionService
        self.questionAnswers = questionAnswers
        self.referenceImages = referenceImages
    }

}
class CartQuestionAnswer: NSObject, Codable {
    
    var questionID = "-1"
    var selectedQuestionName = ""
    var selectedAnswerName = ""
    var answerOptions = [Optiontree]()
    
    override init(){}
    
    init(questionID: String, selectedQuestionName: String, selectedAnswerName: String, answerOptions: [Optiontree]) {
        self.questionID = questionID
        self.selectedQuestionName = selectedQuestionName
        self.selectedAnswerName = selectedAnswerName
        self.answerOptions = answerOptions
    }
}

class CartReferenceImage: NSObject, Codable {
    var imageUrl = ""
    
    override init(){}
    
    init(imageUrl: String) {
        self.imageUrl = imageUrl
    }
}
enum SortByTap {
    case lowPrice, highPrice, nearestLocation
}

