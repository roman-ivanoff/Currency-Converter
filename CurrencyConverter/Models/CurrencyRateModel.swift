//
//  CurrencyRateModel.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 04.10.2022.
//

import Foundation

class CurrencyRateModel {
    var currencyRate: [CurrencyRate]?
    var popularCurrencies: [CurrencyRate] = []
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
//                self.currencyRate = rates.wrappedValue
                self.getPopularCurrencies(currencies: rates.wrappedValue)
                self.lastUpdateDate = rates.createdAt
            case let .failure(error):
                // TODO: handle error
                print(error)
            }
        }
    }

    func getPopularCurrencies(currencies: [CurrencyRate]) {
        guard let uah = getCurrecyByName(name: "UAH", currencies: currencies) else {
            return
        }

        guard let usd = getCurrecyByName(name: "USD", currencies: currencies) else {
            return
        }

        guard let eur = getCurrecyByName(name: "EUR", currencies: currencies) else {
            return
        }

        popularCurrencies.append(uah)
        popularCurrencies.append(usd)
        popularCurrencies.append(eur)
    }

    private func getCurrecyByName(name: String, currencies: [CurrencyRate]) -> CurrencyRate? {
        return currencies.filter({ $0.currency.rawValue == name }).first
    }
}
