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
        #if DEBUG

        if ProcessInfo.processInfo.arguments.contains("mock") {
            let sampleData = ArchiveOfExchangeRate(
                date: "09.11.2022",
                bank: "PB",
                baseCurrency: 980,
                baseCurrencyLit: .uah,
                exchangeRate: [
                    ExchangeRate(
                        baseCurrency: .uah,
                        saleRateNB: 23.6763000,
                        purchaseRateNB: 23.6763000,
                        currency: nil,
                        saleRate: nil,
                        purchaseRate: nil
                    ),
                    ExchangeRate(
                        baseCurrency: .uah,
                        saleRateNB: 36.5375000,
                        purchaseRateNB: 36.5375000,
                        currency: "EUR",
                        saleRate: 39.7000000,
                        purchaseRate: 38.7000000
                    ),
                    ExchangeRate(
                        baseCurrency: .uah,
                        saleRateNB: 36.5686000,
                        purchaseRateNB: 36.5686000,
                        currency: "USD",
                        saleRate: 40.2000000,
                        purchaseRate: 39.7000000
                    ),
                    ExchangeRate(
                        baseCurrency: .uah,
                        saleRateNB: 1.0000000,
                        purchaseRateNB: 1.0000000,
                        currency: "UAH",
                        saleRate: nil,
                        purchaseRate: nil
                    ),
                    ExchangeRate(
                        baseCurrency: .uah,
                        saleRateNB: 7.7847000,
                        purchaseRateNB: 7.7847000,
                        currency: "PLN",
                        saleRate: 8.5700000,
                        purchaseRate: 7.8000000
                    )
                ]
            )

            DispatchQueue.main.async {
                completion(.success(sampleData))
            }

            return
        }

        #endif
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
