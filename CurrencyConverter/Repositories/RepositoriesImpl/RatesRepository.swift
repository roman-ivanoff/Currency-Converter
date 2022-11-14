//
//  RatesRepository.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 29.09.2022.
//

import Foundation

class RatesRepository<L: RatesLocalDataSourceProtocol, R: RatesRemoteDataSourceProtocol>: RatesRepositoryProtocol {
    private var localDataSource: L
    private let remoteDataSource: R

    init(localDataSource: L, remoteDataSource: R) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }

    func fetchRates(date: Date, completion: @escaping (Result<Timestamped<[CurrencyRate]>, Error>) -> Void) {
        if let localRates = localDataSource.rates, localRates.createdAt.isTheSameHour,
            let lastRecievedDate = localDataSource.rates?.lastReceivedDate,
            lastRecievedDate.isTheSameDate(date: date) {
            print("locale")
            completion(.success(localRates))
        } else {
            remoteDataSource.fetchRates(date: date) { result in
                print("remote")
                switch result.map({ Timestamped(wrappedValue: $0, lastReceivedDate: date) }) {
                case let .success(rates):
                    self.localDataSource.rates = rates
                    completion(.success(rates))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }

    func sortRates(currencyRate: [CurrencyRate]) -> [CurrencyRate] {
        return currencyRate.sorted {
            $0.currency.rawValue < $1.currency.rawValue
        }
    }
}
