//
//  CurrencyRateModel.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 04.10.2022.
//

import Foundation

class CurrencyRateModel {
    var currencyRate: [CurrencyRate]?
    var lastUpdateDate: Date?
    let repository = RatesRepository(
        localDataSource: RatesLocalDataSource(),
        remoteDataSource: RatesRemoteDataSource()
    )

    func getRates() {
        repository.fetchRates { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case let .success(rates):
                self.currencyRate = rates.wrappedValue
                self.lastUpdateDate = rates.createdAt
            case let .failure(error):
                // TODO: handle error
                print(error)
            }
        }
    }

    func sortRates() -> [CurrencyRate] {
        return self.currencyRate!.sorted {
            $0.currency.rawValue < $1.currency.rawValue
        }
    }
}
