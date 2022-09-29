//
//  RatesLocalDataSource.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 29.09.2022.
//

import Foundation

class RatesLocalDataSource: RatesLocalDataSourceProtocol {
    @CodableUserDefault(key: UserDefaultsKeys.currencyRate)
    var rates: Timestamped<[CurrencyRate]>?
}
