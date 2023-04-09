//
//  DateConversionExtension.swift
//  Done
//
//  Created by Mazhar Hussain on 5/30/22.
//

import Foundation

extension Date {

    func formatAsyyyyMMdd() -> String {
        return DateFormatter.yyyyMMdd.string(from: self)
    }

    //Calendar popover
    func formatAsMMMM() -> String {
        return DateFormatter.MMMM.string(from: self)
    }

    func formatAsMonthYYYY() -> String {
        return DateFormatter.monthYYYY.string(from: self)
    }

    func formatAsyyyyMMddWithDash() -> String {
        return DateFormatter.yyyyMMddWithDash.string(from: self)
    }

    func formatAsMMddyyyyWithDash() -> String {
        return DateFormatter.MMddyyyyWithDash.string(from: self)
    }

    //WF2, API1, startDate and endDate
    func formatAsMMddyyyy() -> String {
        return DateFormatter.MMDDYYYY.string(from: self)
    }

    func formatAsMMddyyTime12Hours() -> String {
        return DateFormatter.mmddyyTime12Hours.string(from: self)
    }
    func formatAsyyyyddmmTime12Hours() -> String {
        return DateFormatter.yyyyddmmTime12Hours.string(from: self)
    }

    func formatAsMMddyyyyTime12Hours() -> String {
        return DateFormatter.mmddyyyyTime12Hours.string(from: self)
    }

    func formatAsMMddyyyyTime12HourswithSeconds() -> String {
        return DateFormatter.mmddyyyyTime12HourswithSeconds.string(from: self)
    }

    func formatAshmma() -> String {
        return DateFormatter.hmma.string(from: self)
    }

    func formatAsMonthddyyyy() -> String {
        return DateFormatter.monthddyyyy.string(from: self)
    }

    func formatAsFullDayName() -> String {
        return DateFormatter.dayOnly.string(from: self)
    }

    func formatAsMMMddyyyy() -> String {
        return DateFormatter.MMMddyyyy.string(from: self)
    }

    func formatAsMMddyy() -> String {
        return DateFormatter.MMddyy.string(from: self)
    }

    func formatAsMMMdd() -> String {
        return DateFormatter.MMMdd.string(from: self)
    }

    func formatAsMMDDYYYYWithoutSlash() -> String {
        return DateFormatter.MMDDYYYYWithoutSlash.string(from: self)
    }

    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate

        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }

    // Get difference between 2 dates
    func interval(of component: Calendar.Component, from date: Date) -> Int {
        let calendar = Calendar.current
        guard let start = calendar.ordinality(of: component, in: .era, for: date) else { return 0 }
        guard let end = calendar.ordinality(of: component, in: .era, for: self) else { return 0 }

        return end - start
    }

    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
