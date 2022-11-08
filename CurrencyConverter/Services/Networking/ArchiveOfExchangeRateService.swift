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
        date: Date,
        completion: @escaping(Result<ArchiveOfExchangeRate, QueryServiceError>) -> Void
    ) {
        dataTask?.cancel()

        let exchangeRateDate = getStringFromDate(date: date)

        if var urlComponents = URLComponents(string: link) {
            urlComponents.queryItems = [
                URLQueryItem(name: "json", value: nil),
                URLQueryItem(name: "date", value: exchangeRateDate)
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
                    let postResponse = try decoder.decode(ArchiveOfExchangeRate.self, from: jsonData)
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

    private func getStringFromDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d.M.YYYY"

        return formatter.string(from: date)
    }
}
