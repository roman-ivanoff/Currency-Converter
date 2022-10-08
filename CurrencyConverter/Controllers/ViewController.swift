//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 12.09.2022.
//

import UIKit

// swiftlint: disable: force_cast
class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var firstEllipse: UIView!
    @IBOutlet weak var converterView: UIView!
    @IBOutlet weak var lastUpdatedDateLabel: UILabel!
    @IBOutlet weak var lastUpdatedTextLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var addCurrencyButton: UIButton!

    let currencyRateModel = CurrencyRateModel()
    var popularCurrencies: [CurrencyRate] = []

    var isSell = true
    var isBuy = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setConverterView()
        currencyRateModel.getRates()
        self.lastUpdatedDateLabel.text =  self.formatDate(date: currencyRateModel.lastUpdateDate ?? Date())
    }

    private func setConverterView() {
        converterView.layer.cornerRadius = 10

        converterView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        converterView.layer.shadowOpacity = 1
        converterView.layer.shadowRadius = 4
        converterView.layer.shadowOffset = CGSize(width: 0, height: 4)

        lastUpdatedTextLabel.setLineHeight(lineHeight: 1.46)
        lastUpdatedDateLabel.setLineHeight(lineHeight: 1.46)

        let segmentControlFont = UIFont(name: "Lato-Regular", size: 18)
        let segmentControlFont2 = UIFont(name: "Helvetica", size: 18)
        let normalAttribute: [NSAttributedString.Key: Any] = [
            .font: segmentControlFont ?? segmentControlFont2,
            .foregroundColor: UIColor(named: "buttonTextColor")!
        ]
        segmentedControl.setTitleTextAttributes(normalAttribute, for: .normal)

        let selectedAttribute: [NSAttributedString.Key: Any] = [
            .font: segmentControlFont ?? segmentControlFont2,
            .foregroundColor: UIColor.white
        ]
        segmentedControl.setTitleTextAttributes(selectedAttribute, for: .selected)
    }

    private func getPopularCurrencies() {
        guard let uah = getCurrecyByName("UAH") else {
            return
        }

        guard let usd = getCurrecyByName("USD") else {
            return
        }

        guard let eur = getCurrecyByName("EUR") else {
            return
        }

        popularCurrencies.append(uah)
        popularCurrencies.append(usd)
        popularCurrencies.append(eur)
    }

    private func getCurrecyByName(_ name: String) -> CurrencyRate? {
        return currencyRateModel.currencyRate!.filter({ $0.currency.rawValue == name }).first
    }

    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy h:mm a"

        return formatter.string(from: date)
    }

    @IBAction func hangeCurrencyBuySell(_ sender: UISegmentedControl) {
    }
}

extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destController = segue.destination as! CurrencyListViewController
        destController.currencyRate = currencyRateModel.sortRates()
    }
}
