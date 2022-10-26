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

    func getRates(completion: @escaping (Result<Timestamped<[CurrencyRate]>, Error>) -> Void) {
        repository.fetchRates { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case let .success(rates):
                self.popularCurrencies = self.getPopularCurrencies(currencies: rates.wrappedValue)
                self.lastUpdateDate = rates.createdAt
                completion(.success(rates))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func getPopularCurrencies(currencies: [CurrencyRate]) -> [CurrencyRate] {
        let popularRates = ["UAH", "USD", "EUR"]
        return currencies.filter { popularRates.contains($0.currency.rawValue) }
    }

    private func getCurrecyByName(name: String, currencies: [CurrencyRate]) -> CurrencyRate? {
        return currencies.filter({ $0.currency.rawValue == name }).first
    }
}
