//
//  onboardingViewModel.swift
//  Done
//
//  Created by Mazhar Hussain on 01/06/2022.
//

import Foundation
import Localize_Swift

class OnboardingViewModel {
    
    var pages = [Page]()
    
    func getPages() {
        pages = [Page(sliderTitle: "250 + Services".localized(), sliderDetail:"The number one app for Home Repairing,Electronics, Car Repair & more - just a tap away".localized(),
                      sliderImage: "onBoarding1"),
                 Page(sliderTitle: "Qualified and Verified Professionals".localized(), sliderDetail: "DONE Heroes are fully trained and always ready to make your life easier".localized(),
                      sliderImage: "onBoarding2"),
                 Page(sliderTitle: "Unmatched Quality and Prices".localized(), sliderDetail: "The DONE Guarantee - providing our customers the best quality service at the best price".localized(), sliderImage: "onBoarding3")
        ]
        
    }
}



