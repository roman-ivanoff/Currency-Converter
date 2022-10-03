//
//  RatesRepository.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 29.09.2022.
//

import Foundation

class RatesRepository: RatesRepositoryProtocol {
    private let localDataSource: RatesLocalDataSource
    private let remoteDataSource: RatesRemoteDataSource

    init(localDataSource: RatesLocalDataSource, remoteDataSource: RatesRemoteDataSource) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }

    func fetchRates(completion: @escaping (Result<Timestamped<[CurrencyRate]>, Error>) -> Void) {
        if let localRates = localDataSource.rates, localRates.createdAt.isTheSameHour {
            print("locale")
            completion(.success(localRates))
        } else {
            remoteDataSource.fetchRates { [localDataSource] result in
                print("remote")
                switch result.map({ Timestamped(wrappedValue: $0) }) {
                case let .success(rates):
                    localDataSource.rates = rates
                    completion(.success(rates))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
}
