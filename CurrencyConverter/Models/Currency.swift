//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 29.09.2022.
//

import Foundation

struct Currency: RawRepresentable, Codable, Equatable, CustomStringConvertible {
    let rawValue: String

    var description: String { rawValue }
}
