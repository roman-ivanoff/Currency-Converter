//
//  LocalStorageRepository.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 23.09.2022.
//

import Foundation

protocol LocalStorageRepository {
    func getRates() -> [ExchangeRate]?
    func updateRates(rates: [ExchangeRate])
}
