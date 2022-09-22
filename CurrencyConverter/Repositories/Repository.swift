//
//  Repository.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 22.09.2022.
//

import Foundation

protocol Repository {
    associatedtype T

    func create()
    func getAll() -> [T]?
    func get(objectWith id: String) -> T?
    func update(objectWith id: String)
    func delete(objectWith id: String)
}
