//
//  CurrencyRate+Description.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 29.09.2022.
//

import Foundation

extension CurrencyRate: CustomDebugStringConvertible {
    var debugDescription: String {
        """

        CurrencyRate
        base: \(base)
        currency: \(currency)
        sale: \(sale)
        purchase: \(purchase)
        """
    }
}
