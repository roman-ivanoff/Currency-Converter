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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addCurrencyButton: UIButton!

    let currencyRateModel = CurrencyRateModel()
    var popularCurrencies: [CurrencyRate] = []

    var isSell = true
    var isBuy = false

    let cellId = "currencyCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        setConverterView()
        currencyRateModel.getRates { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .success:
                if let selectedCurrency = self.currencyRateModel.selectedCurrency {
                    self.currencyRateModel.popularCurrencies.append(selectedCurrency)
                }
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.showHiddenView()
            case let .failure(error):
                let dialogMessage = UIAlertController(
                    title: "Error",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(title: "OK", style: .cancel)
                dialogMessage.addAction(okAction)
                self.present(dialogMessage, animated: true)
            }
        }
        self.lastUpdatedDateLabel.text =  self.formatDate(date: currencyRateModel.lastUpdateDate ?? Date())

        tableView.delegate = self
        tableView.dataSource = self

        registerCell(for: "CurrencyTableViewCell", id: cellId)
    }

    private func registerCell(for nibName: String, id: String) {
        tableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: id)
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
        segmentedControl.removeBorders()
    }

    private func showHiddenView() {
        segmentedControl.isHidden = false
        tableView.isHidden = false
        shareButton.isHidden = false
        addCurrencyButton.isHidden = false
    }

    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy h:mm a"

        return formatter.string(from: date)
    }

    @IBAction func addCurrencyAction(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(identifier: "currencyList", creator: { coder in
            return CurrencyListViewController(coder: coder, sections: self.currencyRateModel.allCurrenciesInSections)
        }) else {
            fatalError("Failed to load CurrencyListViewController from storyboard.")
        }

        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func hangeCurrencyBuySell(_ sender: UISegmentedControl) {
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyRateModel.popularCurrencies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = UITableViewCell()

        if let customCell = tableView.dequeueReusableCell(
            withIdentifier: cellId,
            for: indexPath
        ) as? CurrencyTableViewCell {

            customCell.currencyNameLabel.text = currencyRateModel.popularCurrencies[indexPath.row].currency.rawValue

            cell = customCell
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
