//
//  MockRatesLocalDataSource.swift
//  CurrencyConverterTests
//
//  Created by Roman Ivanov on 14.11.2022.
//

import Foundation
@testable import CurrencyConverter

class MockRatesLocalDataSource: RatesLocalDataSourceProtocol {
    var rates: CurrencyConverter.Timestamped<[CurrencyConverter.CurrencyRate]>?

    static func getSampleData() -> Timestamped<[CurrencyRate]> {
        let currencyRates = [
            CurrencyRate(
                base: Currency(rawValue: "UAH"),
                currency: Currency(rawValue: "USD"),
                sale: 1.22,
                purchase: 1.11
            ),
            CurrencyRate(
                base: Currency(rawValue: "UAH"),
                currency: Currency(rawValue: "EUR"),
                sale: 1.33,
                purchase: 1.22
            ),
            CurrencyRate(
                base: Currency(rawValue: "UAH"),
                currency: Currency(rawValue: "UAH"),
                sale: 1,
                purchase: 1
            ),
            CurrencyRate(
                base: Currency(rawValue: "UAH"),
                currency: Currency(rawValue: "UZS"),
                sale: 1.03,
                purchase: 1.02
            )
        ]

        return Timestamped(wrappedValue: currencyRates, lastReceivedDate: MockRatesLocalDataSource.getConstantDate())
    }

    static func getConstantDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.date(from: "2016/10/08 22:31")!
    }
}
