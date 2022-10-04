//
//  CurrencyRate+Initialization.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 29.09.2022.
//

import Foundation

extension CurrencyRate {
    init?(response source: ExchangeRate) {
        guard let currency = source.currency else {
            return nil
        }
        self.init(
            base: Currency(rawValue: source.baseCurrency.rawValue),
            currency: Currency(rawValue: currency),
            sale: Decimal(source.saleRateNB),
            purchase: Decimal(source.purchaseRateNB)
        )
    }
}
