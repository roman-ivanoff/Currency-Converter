//
//  PopularExchangeRates.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 21.09.2022.
//

import Foundation

struct PopularExchangeRates: Codable {
    let ccy: String
    let baseCcy: String
    let buy: String
    let sale: String

    enum CodingKeys: String, CodingKey {
        case ccy
        case baseCcy = "base_ccy"
        case buy
        case sale
    }
}
