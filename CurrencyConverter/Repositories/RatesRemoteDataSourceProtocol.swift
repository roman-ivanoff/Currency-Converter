//
//  RatesRemoteDataSourceProtocol.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 29.09.2022.
//

import Foundation

protocol RatesRemoteDataSourceProtocol {
    func fetchRates(date: Date, completion: @escaping(Result<[CurrencyRate], Error>) -> Void)
}
