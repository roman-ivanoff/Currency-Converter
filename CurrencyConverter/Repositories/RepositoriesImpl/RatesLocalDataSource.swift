//
//  RatesLocalDataSource.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 23.09.2022.
//

import Foundation

class RatesLocalDataSource: LocalStorageRepository {
    let key = "ExhangeRates"

    func getRates() -> [ExchangeRate]? {
        return UserDefaults.standard.array(forKey: key) as? [ExchangeRate] ?? nil
    }

    func updateRates(rates: [ExchangeRate]) {
        UserDefaults.standard.set(rates, forKey: key)
    }
}
