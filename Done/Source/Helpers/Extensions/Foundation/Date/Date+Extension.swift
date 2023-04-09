//
//  Date+Extension.swift
//  Done
//
//  Created by Mazhar Hussain on 5/30/22.
//

import Foundation
import SwiftDate

extension Date {

    func removeTimeStamp() -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            return self
        }
        return date
    }

    func byDroppingSeconds() -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)) else {
            return self
        }
        return date
    }

    func sameDay(toDate: Date?) -> Bool {
        if let otherData = toDate {
            return self.compare(toDate: otherData, granularity: .day) == .orderedSame
        }
        return false
    }

    // return yesterday's date
    static func yesterday() -> Date {
        return Date().dateByAdding(-1, .day).date
    }

    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }

    func isPastDate() -> Bool {
        return self.startOfDay() < Date().startOfDay()
    }

    func isFutureDate() -> Bool {
        return self.startOfDay() > Date().startOfDay()
    }

    func endOfDay() -> Date {
        let calendar = Calendar.current
        if let nextDay = calendar.date(byAdding: .day, value: 1, to: self) {
            let nextDayStartOfDay = calendar.startOfDay(for: nextDay)
            return calendar.date(byAdding: .second, value: -1, to: nextDayStartOfDay) ?? nextDayStartOfDay
        }
        return self
    }

    func isStartOfLastMonth() -> Bool {
        let startDate = Date().dateByAdding(-1, .month).date
        let comparisonResult = startDate.compare(toDate: self, granularity: .day)
        return comparisonResult == .orderedSame
    }

    func weekDay() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }

    func isTodaysDate() -> Bool {
        return Calendar.current.isDateInToday(self)
    }

    func isYesterdaysDate() -> Bool {
        return Calendar.current.isDateInYesterday(self)
    }

    func minutesFrom(_ date: Date) -> Int {
        return Int(self.timeIntervalSince(date)/60)
    }

    func hoursFrom(_ date: Date) -> Float {
        return Float(self.timeIntervalSince(date)/3600)
    }
}
func utcToLocal(dateStr: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZ"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    
    if let date = dateFormatter.date(from: dateStr) {
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "h:mm a"
    
        return dateFormatter.string(from: date)
    }
    return nil
}

