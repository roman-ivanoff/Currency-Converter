//
//  MockRatesRemoteDataSource.swift
//  CurrencyConverterTests
//
//  Created by Roman Ivanov on 14.11.2022.
//

import XCTest
@testable import CurrencyConverter

class MockRatesRemoteDataSource: RatesRemoteDataSourceProtocol {

    func fetchRates(date: Date, completion: @escaping (Result<[CurrencyConverter.CurrencyRate], Error>) -> Void) {
        let mockRates = MockRatesLocalDataSource.getSampleData()
        if !mockRates.wrappedValue.isEmpty {
            completion(.success(mockRates.wrappedValue))
        } else {
            completion(.failure(QueryServiceError.noDataAvailable))
        }
    }
}
