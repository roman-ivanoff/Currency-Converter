//
//  CurrencyRate.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 29.09.2022.
//

import Foundation

struct CurrencyRate: Codable, Equatable {
    let base: Currency
    let currency: Currency
    let sale: Decimal
    let purchase: Decimal
}
