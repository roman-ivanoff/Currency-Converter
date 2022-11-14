//
//  Timestamped.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 29.09.2022.
//

import Foundation

struct Timestamped<T: Codable>: Codable, Equatable {
    static func == (lhs: Timestamped<T>, rhs: Timestamped<T>) -> Bool {
        lhs.createdAt == rhs.createdAt
    }
    
    var createdAt = Date()
    let wrappedValue: T
    var lastReceivedDate: Date
}
