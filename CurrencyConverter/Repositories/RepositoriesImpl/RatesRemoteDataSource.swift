//
//  RatesRemoteDataSource.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 29.09.2022.
//

import Foundation

class RatesRemoteDataSource: RatesRemoteDataSourceProtocol {
    let rateService = ArchiveOfExchangeRateService()
    func fetchRates(date: Date, completion: @escaping (Result<[CurrencyRate], Error>) -> Void) {
        rateService.getExchangeRate(date: date) { result in
            switch result {
            case .success(let rates):
                let response = rates.exchangeRate
                completion(.success(response.compactMap(CurrencyRate.init(response:))))
            case .failure(let error):
                completion(.failure(NSError(domain: error.localizedDescription, code: -1)))
            }
        }
    }
}
