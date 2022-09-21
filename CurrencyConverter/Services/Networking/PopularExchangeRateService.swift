//
//  PopularExchangeRateService.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 21.09.2022.
//

import Foundation

class PopularExchangeRateService {
    var session: URLSession
    let link = "https://api.privatbank.ua/p24api/pubinfo?json&exchange&coursid=5"
    var dataTask: URLSessionDataTask?

    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }

    func getExchangeRate(completion: @escaping(Result<PopularExchangeRates, QueryServiceError>) -> Void) {
        dataTask?.cancel()

        guard let url = URL(string: link) else {
            return
        }

        dataTask = session.dataTask(with: url) { data, _, _ in
            guard let jsonData = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noDataAvailable))
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                let postResponse = try decoder.decode(PopularExchangeRates.self, from: jsonData)
                DispatchQueue.main.async {
                    completion(.success(postResponse))
                }
            } catch {
                print("error:---------- \(data)")
                DispatchQueue.main.async {
                    completion(.failure(.cannotProcessData))
                }
            }
        }

        dataTask?.resume()
    }
}
