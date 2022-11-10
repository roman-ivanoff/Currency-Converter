//
//  ServiceTests.swift
//  CurrencyConverterTests
//
//  Created by Roman Ivanov on 10.11.2022.
//

import XCTest
@testable import CurrencyConverter

class QueryServiceTests: XCTestCase {
    var urlSession: URLSession!

    override func setUpWithError() throws {
        let queryService = ArchiveOfExchangeRateService(session: urlSession)

        let sampleData = getSampleData()
        let mockData = try JSONEncoder().encode(sampleData)

        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), mockData)
        }

        let expectation = XCTestExpectation(description: "response")

        queryService.getExchangeRate(date: Date()) { result in
            switch result {
            case .success(let rates):
                XCTAssertEqual(sampleData, rates)
            case .failure(let error):
                XCTAssertEqual(error, QueryServiceError.noDataAvailable)
            }
        }

        self.wait(for: [expectation], timeout: 1)
    }

    private func getSampleData() -> ArchiveOfExchangeRate {
        return ArchiveOfExchangeRate(
            date: "09.11.2022",
            bank: "PB",
            baseCurrency: 980,
            baseCurrencyLit: .uah,
            exchangeRate: [
                ExchangeRate(
                    baseCurrency: .uah,
                    saleRateNB: 23.6763000,
                    purchaseRateNB: 23.6763000,
                    currency: nil,
                    saleRate: nil,
                    purchaseRate: nil
                ),
                ExchangeRate(
                    baseCurrency: .uah,
                    saleRateNB: 36.5375000,
                    purchaseRateNB: 36.5375000,
                    currency: "EUR",
                    saleRate: 39.7000000,
                    purchaseRate: 38.7000000
                ),
                ExchangeRate(
                    baseCurrency: .uah,
                    saleRateNB: 36.5686000,
                    purchaseRateNB: 36.5686000,
                    currency: "USD",
                    saleRate: 40.2000000,
                    purchaseRate: 39.7000000
                ),
                ExchangeRate(
                    baseCurrency: .uah,
                    saleRateNB: 1.0000000,
                    purchaseRateNB: 1.0000000,
                    currency: "UAH",
                    saleRate: nil,
                    purchaseRate: nil
                ),
                ExchangeRate(
                    baseCurrency: .uah,
                    saleRateNB: 7.7847000,
                    purchaseRateNB: 7.7847000,
                    currency: "PLN",
                    saleRate: 8.5700000,
                    purchaseRate: 7.8000000
                )
            ]
        )
    }
}

