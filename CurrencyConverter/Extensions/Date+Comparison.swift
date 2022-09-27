//
//  Date+Comparison.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 27.09.2022.
//

import Foundation

extension Date {
    var hasHourPassed: Bool {
        let currentDate = Calendar.current.dateComponents([.hour, .day, .month, .year], from: Date())
        let lastUpdateDate = Calendar.current.dateComponents([.hour, .day, .month, .year], from: self)

        return currentDate.hour ?? 0 > lastUpdateDate.hour ?? 0 ||
            currentDate.day ?? 0 > lastUpdateDate.day ?? 0 ||
            currentDate.month ?? 0 > lastUpdateDate.month ?? 0 ||
            currentDate.year ?? 0 > lastUpdateDate.year ?? 0
    }
}
