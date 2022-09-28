//
//  Date+Comparison.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 28.09.2022.
//

import Foundation

extension Date {
    var hasHourPassed: Bool {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        return  calendar.compare(self, to: Date(), toGranularity: .hour).rawValue != 0
    }
}
