//
//  ArchiveOfExchangeRate.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 20.09.2022.
//

import Foundation

struct ArchiveOfExchangeRate: Codable {
    let date: String
    let bank: String
    let baseCurrency: Int
    let baseCurrencyLit: BaseCurrency
    let exchangeRate: [ExchangeRate]
}
