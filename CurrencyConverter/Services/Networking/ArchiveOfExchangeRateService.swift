//
//  ArchiveOfExchangeRateService.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 21.09.2022.
//

import Foundation

class ArchiveOfExchangeRateService {
    var session: URLSession
    let link = "https://api.privatbank.ua/p24api/exchange_rates"
    var dataTask: URLSessionDataTask?

    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }

    func getExchangeRate(
        date: String = "",
        completion: @escaping(Result<ArchiveOfExchangeRate, QueryServiceError>) -> Void
    ) {
        dataTask?.cancel()

        var exchangeRateDate = date.isEmpty ? getCurrentDate() : date

        if var urlComponents = URLComponents(string: link) {
            urlComponents.queryItems = [URLQueryItem(name: "json", value: nil), URLQueryItem(name: "date", value: exchangeRateDate)]

            guard let url = urlComponents.url else {
                return
            }

            dataTask = session.dataTask(with: url) { data, _, error in
                guard let jsonData = data else {
                    DispatchQueue.main.async {
                        completion(.failure(.noDataAvailable))
                    }
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let postResponse = try decoder.decode(ArchiveOfExchangeRate.self, from: jsonData)
                    DispatchQueue.main.async {
                        completion(.success(postResponse))
                    }
                } catch {
                    print(error)
                    DispatchQueue.main.async {
                        completion(.failure(.cannotProcessData))
                    }
                }
            }

            dataTask?.resume()
        }
    }

    private func getCurrentDate() -> String {
        let currentDate = Date()
        let calendar = Calendar.current
        let requestComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day
        ]

        let dateComponents = calendar.dateComponents(requestComponents, from: currentDate)

        return "\(dateComponents.day!).\(dateComponents.month!).\(dateComponents.year!)"
    }
}
