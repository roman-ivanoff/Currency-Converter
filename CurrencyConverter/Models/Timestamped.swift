//
//  Timestamped.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 29.09.2022.
//

import Foundation

struct Timestamped<T: Codable>: Codable {
    var createdAt = Date()
    let wrappedValue: T
}
