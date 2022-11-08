//
//  RatesRepositoryProtocol.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 29.09.2022.
//

import Foundation

protocol RatesRepositoryProtocol {
    func fetchRates(date: Date, completion: @escaping(Result<Timestamped<[CurrencyRate]>, Error>) -> Void)
}
