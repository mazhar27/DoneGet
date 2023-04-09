//
//  UIColor-Extension.swift
//  Done
//
//  Created by Mazhar Hussain on 01/06/2022.
//

import Foundation
import UIKit

extension UIColor {
    
    static var blueThemeColor: UIColor {
        return UIColor(red:0/255, green:125/255 ,blue:198/255 , alpha:1)
    }
    static var disableBackgroundColor: UIColor {
        return UIColor(red:0/255, green:0/255 ,blue:0/255 , alpha:0.16)
    }
    static var disableLblColor: UIColor {
        return UIColor(red:0/255, green:0/255 ,blue:0/255 , alpha:0.16)
    }
    static var lightGrayThemeColor: UIColor {
        return UIColor(red:172/255, green:172/255 ,blue:172/255 , alpha:1)
    }
    
    static var couponTintColor: UIColor {
        return UIColor(red:217/255, green:217/255 ,blue:217/255 , alpha:1)
    }
    
    static var greenCompleteJobColor: UIColor {
        return UIColor(red:51/255, green:146/255 ,blue:125/255 , alpha:1)
    }
    
    static var greenCompleteJobDisabledColor: UIColor {
        return UIColor(red:51/255, green:146/255 ,blue:125/255 , alpha:0.5)
    }
    
    static var grayThemeColor: UIColor {
        return UIColor(red:69/255, green:69/255 ,blue:69/255 , alpha:1)
    }
    static var grayTextColor: UIColor {
        return UIColor(red:71/255, green:71/255 ,blue:71/255 , alpha:1)
    }
    
    static var calendarDisableGrayColor: UIColor {
        return UIColor(red:180/255, green:180/255 ,blue:180/255 , alpha:1)
    }
    
    static var timeSlotBookedColor: UIColor {
        return UIColor(red:235/255, green:87/255 ,blue:104/255 , alpha:1)
    }
    
    static var timeSlotCartBooked: UIColor {
        return UIColor(red:204/255, green:204/255 ,blue:204/255 , alpha:1)
    }
    
    static var navigationBarTintColor: UIColor {
        return UIColor(red:227/255, green:246/255 ,blue:249/255 , alpha:1)
    }
    
    static var labelTitleColor: UIColor {
        return UIColor(red:71/255, green:71/255 ,blue:71/255 , alpha:1)
    }
    
    static var buttonThemeColor: UIColor {
        return UIColor(red:18/255, green:125/255 ,blue:198/255 , alpha:1)
    }
    
    static var buttonRedColor: UIColor {
        return UIColor(red:230/255, green:100/255 ,blue:105/255 , alpha:1)
    }
    static var selectedServiceShadowColor: UIColor {
        return UIColor(red:0/255, green:125/255 ,blue:198/255 , alpha:0.29)
    }
    static var unselectedServiceShadowColor: UIColor {
        return UIColor(red:0/255, green:0/255 ,blue:0/255 , alpha:0.11)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
}

