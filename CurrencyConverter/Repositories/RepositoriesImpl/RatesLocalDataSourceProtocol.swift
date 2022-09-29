//
//  RatesLocalDataSourceProtocol.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 29.09.2022.
//

import Foundation

protocol RatesLocalDataSourceProtocol {
    var rates: Timestamped<[CurrencyRate]>? { get set }
}
