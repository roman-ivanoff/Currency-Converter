//
//  Repository.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 22.09.2022.
//

import Foundation

protocol Repository {
    func getExchangeRatesFromRemote() -> [ExchangeRate]
    func getExchangeRatesFromLocale() -> [ExchangeRate]
    func saveExchangeRates(rates: [ExchangeRate])
}
