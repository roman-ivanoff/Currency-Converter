//
//  PopularExchangeRateService.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 21.09.2022.
//

import Foundation

class PopularExchangeRateService {
    var session: URLSession
    let link = "https://api.privatbank.ua/p24api/pubinfo"
    var dataTask: URLSessionDataTask?

    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }

    func getExchangeRate(completion: @escaping(Result<[PopularExchangeRates], QueryServiceError>) -> Void) {
        dataTask?.cancel()

        if var urlComponents = URLComponents(string: link) {
            urlComponents.queryItems = [
                URLQueryItem(name: "json", value: nil),
                URLQueryItem(name: "exchange", value: nil),
                URLQueryItem(name: "coursid", value: "5")
            ]

            guard let url = urlComponents.url else {
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
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let postResponse = try decoder.decode([PopularExchangeRates].self, from: jsonData)
                    DispatchQueue.main.async {
                        completion(.success(postResponse))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(.cannotProcessData))
                    }
                }
            }

            dataTask?.resume()
        }
    }
}
