//
//  QueryServiceError.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 21.09.2022.
//

import Foundation

enum QueryServiceError: Error {
    case noDataAvailable
    case cannotProcessData
}
