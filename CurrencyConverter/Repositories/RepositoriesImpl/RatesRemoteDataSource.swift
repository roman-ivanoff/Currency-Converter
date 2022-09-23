//
//  RatesRemoteDataSource.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 23.09.2022.
//

import Foundation

class RatesRemoteDataSource: RemoteStorageRepository {
    let archiveRates = ArchiveOfExchangeRateService()
    func getRates() -> [ExchangeRate] {
        var rates: [ExchangeRate] = []
        archiveRates.getExchangeRate { result in
            switch result {
            case .failure(let error):
                // do something
                break
            case .success(let rate):
                rates = rate.exchangeRate
            }
        }

        return rates
    }
}
