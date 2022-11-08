//
//  Date+Comparison.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 28.09.2022.
//

import Foundation

extension Date {
    var isTheSameHour: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .hour)
    }

    func isTheSameDate(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .year) &&
        Calendar.current.isDate(self, equalTo: date, toGranularity: .month) &&
        Calendar.current.isDate(self, equalTo: date, toGranularity: .day)
    }
}
