//
//  ExchangeRate.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 20.09.2022.
//

import Foundation

struct ExchangeRate: Codable, Equatable {
    let baseCurrency: BaseCurrency
    let saleRateNB: Double
    let purchaseRateNB: Double
    let currency: String?
    let saleRate: Double?
    let purchaseRate: Double?
}
