//
//  DataManager.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 23.09.2022.
//

import Foundation

class DataManager: Repository {
    private let localDataSource: RatesLocalDataSource
    private let remoteDataSource: RatesRemoteDataSource

    init() {
        localDataSource = RatesLocalDataSource()
        remoteDataSource = RatesRemoteDataSource()
    }

    func getExchangeRatesFromRemote() -> [ExchangeRate] {
        return remoteDataSource.getRates()
    }

    func getExchangeRatesFromLocale() -> [ExchangeRate] {
        // check time and from call remote or locale
        return remoteDataSource.getRates()
    }

    func saveExchangeRates(rates: [ExchangeRate]) {
        localDataSource.updateRates(rates: rates)
    }
}
