//
//  UserDefaultsArchiveOfExchangeRateRepository.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 22.09.2022.
//

import Foundation

//class UserDefaultsArchiveOfExchangeRateRepository: Repository {
//    typealias T = DomainArchiveOfExchangeRate
//
//    let rate = ArchiveOfExchangeRateService()
//    var archiveRates: [DomainArchiveOfExchangeRate] = []
//
//    func create() {
//        // check if userDefaults exists and getExchangeRate???
//        getExchangeRate()
//        if !archiveRates.isEmpty {
//            for archiveRate in archiveRates {
//                UserDefaults.standard.set(archiveRate, forKey: archiveRate.id)
//            }
//        }
//    }
//
//    func getAll() -> [DomainArchiveOfExchangeRate]? {
//        // currenTime - lastTime > 1 hour -> update and get all
//        return [DomainArchiveOfExchangeRate(id: "1", currency: "1", sale: 1, purchase: 1)]
//    }
//
//    func get(objectWith id: String) -> DomainArchiveOfExchangeRate? {
//        guard let rate = UserDefaults.standard.object(forKey: id) as? DomainArchiveOfExchangeRate else {
//            return nil
//        }
//
//        return rate
//    }
//
//    func update(objectWith id: String) {
//        // do something
//    }
//
//    func delete(objectWith id: String) {
//        // do something
//    }
//
//    func getExchangeRate() {
//        rate.getExchangeRate { [self] result in
//            switch result {
//            case .failure(let error):
//                // do something
//                break
//            case .success(let rates):
//                for exchangeRate in rates.exchangeRate {
//                    archiveRates.append(DomainArchiveOfExchangeRate(
//                        id: exchangeRate.currency ?? "-1",
//                        currency: exchangeRate.currency ?? "-1",
//                        sale: exchangeRate.saleRateNB,
//                        purchase: exchangeRate.purchaseRateNB)
//                    )
//                }
//            }
//        }
//    }
//}
