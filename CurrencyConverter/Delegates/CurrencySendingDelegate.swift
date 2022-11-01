//
//  CurrencySendingDelegate.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 01.11.2022.
//

import Foundation

protocol CurrencySendingDelegate: AnyObject {
    func sendCurrency(currency: CurrencyRate)
}
