//
//  RatesRepositoryTests.swift
//  CurrencyConverterTests
//
//  Created by Roman Ivanov on 14.11.2022.
//

import XCTest
@testable import CurrencyConverter

class RatesRepositoryTests: XCTestCase {
    private var mockLocal: MockRatesLocalDataSource!
    private var mockRemote: MockRatesRemoteDataSource!
    private var sut: RatesRepository<MockRatesLocalDataSource, MockRatesRemoteDataSource>!

    override func setUp() {
        mockLocal = MockRatesLocalDataSource()
        mockRemote = MockRatesRemoteDataSource()
        sut = RatesRepository(localDataSource: mockLocal, remoteDataSource: mockRemote)
    }

    override func tearDown() {
        sut = nil
        mockLocal = nil
        mockRemote = nil
    }

    func test_existingLocalData_noRemoteCall() throws {
        let expected = MockRatesLocalDataSource.getSampleData()
        mockLocal.rates = expected
        var receivedRates: Timestamped<[CurrencyRate]>!

        sut.fetchRates(date: MockRatesLocalDataSource.getConstantDate(), completion: { result in
            switch result {
            case .success(let rates):
                receivedRates = rates
            case .failure:
                break
            }
        })

        XCTAssertEqual(expected, receivedRates)
    }

    func test_emptyLocalData_remoteCallErrorRethrow() {
        sut.fetchRates(date: MockRatesLocalDataSource.getConstantDate(), completion: { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTAssertThrowsError(error)
            }
        })
    }

    func test_emptyLocalData_remoteCallStoresDataLocal() throws {
        let expected = MockRatesLocalDataSource.getSampleData()
        mockLocal.rates = expected

        var receivedRates: Timestamped<[CurrencyRate]>!

        sut.fetchRates(date: MockRatesLocalDataSource.getConstantDate(), completion: { result in
            switch result {
            case .success(let rates):
                receivedRates = rates
            case .failure:
                break
            }
        })

        XCTAssertEqual(expected, receivedRates)
        XCTAssertEqual(expected, mockLocal.rates)
    }
}
