//
//  DateFormatterExtension.swift
//  Done
//
//  Created by Mazhar Hussain on 5/30/22.
//

import Foundation

extension DateFormatter {

    static let MMDDYYYY = formatter(format: "MM/dd/yyyy")

    static let MMddyy = formatter(format: "MM/dd/yy")

    static let yyyyMMdd = formatter(format: "yyyy MM dd")

    static let yyyyMMddWithDash = formatter(format: "yyyy-MM-dd")

    static let MMddyyyyWithDash = formatter(format: "MM-dd-yyyy")

    static let mmddyyTime12Hours = formatter(format: "MM/dd/yy hh:mm a")
    
    static let yyyyddmmTime12Hours = formatter(format: "yyyy-MM-dd@hh:mm a")
    static let yyyyddmmTime24Hours = formatter(format: "yyyy-MM-dd@HH:mm ")

    static let mmddyyyyTime12Hours = formatter(format: "MM/dd/yyyy hh:mm a")

    static let hmma = formatter(format: "hh:mm a")

    static let hhmm = formatter(format: "HH:mm")

    static let MMMM = formatter(format: "MMMM")
    
    static let monthYYYY = formatter(format: "MMMM yyyy")
    static let DDmonthYYYYTime = formatter(format: "dd-MM-yyyy hh:mm a")
    
    static let DDmonthYYYY = formatter(format: "dd MMMM yyyy")
    static let DDmonYYYY = formatter(format: "dd MMM yyyy")

    static let monthddyyyy = formatter(format: "MMMM dd, yyyy")

    static let dayOnly = formatter(format: "EEEE")

    static let MMMddyyyy = formatter(format: "MMM dd, yyyy")
    static let DDDDMMMMyyyy =  formatter(format: "EEEE, MMM d, yyyy")

    static let MMMdd = formatter(format: "MMM dd")

    static let MMDDYYYYWithoutSlash = formatter(format: "MMddyyyy")
    
    static let mmddyyyyTime12HourswithSeconds = formatter(format: "MM/dd/yyyy hh:mm:ss a")
    
    static let mmddyyyyTime12HourswithMilliSeconds = formatter(format: "MM/dd/yyyy hh:mm:ss.SS a")

    private static func formatter(format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format

        // Setting locale, so that when user changes date/time format in the device, it does not effect our formatting
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }
}

