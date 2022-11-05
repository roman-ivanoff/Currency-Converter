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
    var allCurrenciesInSections: [Section] = []
    var selectedCurrency: CurrencyRate?
    var lastUpdateDate: Date?
    let repository = RatesRepository(
        localDataSource: RatesLocalDataSource(),
        remoteDataSource: RatesRemoteDataSource()
    )
    var amount: Double = 0

    func getRates(
        onSuccess: @escaping (Timestamped<[CurrencyRate]>) -> Void,
        onError: @escaping(Error) -> Void
    ) {
        repository.fetchRates { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case let .success(rates):
                self.popularCurrencies = self.getPopularCurrencies(currencies: rates.wrappedValue)
                self.lastUpdateDate = rates.createdAt
                self.allCurrenciesInSections = self.getAllRatesSections(
                    popularCurrencies: self.popularCurrencies,
                    currencies: rates.wrappedValue
                )
                onSuccess(rates)
            case let .failure(error):
                onError(error)
            }
        }
    }

//    func getRates(completion: @escaping (Result<Timestamped<[CurrencyRate]>, Error>) -> Void) {
//        repository.fetchRates { [weak self] result in
//            guard let self = self else {
//                return
//            }
//
//            switch result {
//            case let .success(rates):
//                self.popularCurrencies = self.getPopularCurrencies(currencies: rates.wrappedValue)
//                self.lastUpdateDate = rates.createdAt
//                self.allCurrenciesInSections = self.getAllRatesSections(
//                    popularCurrencies: self.popularCurrencies,
//                    currencies: rates.wrappedValue
//                )
//                completion(.success(rates))
//            case let .failure(error):
//                completion(.failure(error))
//            }
//        }
//    }

    func getPopularCurrencies(currencies: [CurrencyRate]) -> [CurrencyRate] {
        var rates: [CurrencyRate] = []
        if let uah = getCurrecyByName(name: "UAH", currencies: currencies) {
            rates.append(uah)
        }
        if let uah = getCurrecyByName(name: "USD", currencies: currencies) {
            rates.append(uah)
        }
        if let uah = getCurrecyByName(name: "EUR", currencies: currencies) {
            rates.append(uah)
        }

        return rates
    }

    func getAllRatesSections(popularCurrencies: [CurrencyRate], currencies: [CurrencyRate]) -> [Section] {
        var sections = [Section]()

        let groupedDictionary = Dictionary(grouping: currencies, by: { $0.currency.rawValue.prefix(1) })
        let sortedRates = groupedDictionary.sorted { $0.0 < $1.0 }

        sections.append(Section(
            sectionName: NSLocalizedString("popular", comment: ""),
            sectionObjects: popularCurrencies)
        )

        for (key, value) in sortedRates {
            sections.append(Section(sectionName: String(key), sectionObjects: value))
        }

        return sections
    }

    private func getCurrecyByName(name: String, currencies: [CurrencyRate]) -> CurrencyRate? {
        return currencies.filter({ $0.currency.rawValue == name }).first
    }
}
