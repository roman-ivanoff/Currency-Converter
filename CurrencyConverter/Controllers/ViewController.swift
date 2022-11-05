//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 12.09.2022.
//

import UIKit

enum ConvertState {
    case withoutConvert
    case uahToOtherCurrencies
    case chosenCurrencyToUah(rowNumber: Int)
}

enum SellBuyState {
    case buy
    case sell
}

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
    var selectedCurrencies: [CurrencyRate] = []
    private var convertState: ConvertState = .withoutConvert
    private var sellBuyState: SellBuyState = .sell {
        didSet {
            tableView.reloadData()
        }
    }

    let cellId = "currencyCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        setConverterView()

        currencyRateModel.getRates { [weak self] _ in
            guard let self = self else {
                return
            }
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.showHiddenView()
        } onError: { error in
            let dialogMessage = UIAlertController(
                title: "Error",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "OK", style: .cancel)
            dialogMessage.addAction(okAction)
            self.present(dialogMessage, animated: true)
        }

//        currencyRateModel.getRates { [weak self] result in
//            guard let self = self else {
//                return
//            }
//
//            switch result {
//            case .success:
//                if let selectedCurrency = self.currencyRateModel.selectedCurrency {
//                    self.currencyRateModel.popularCurrencies.append(selectedCurrency)
//                }
//                self.tableView.reloadData()
//                self.activityIndicator.stopAnimating()
//                self.showHiddenView()
//            case let .failure(error):
//                let dialogMessage = UIAlertController(
//                    title: "Error",
//                    message: error.localizedDescription,
//                    preferredStyle: .alert
//                )
//                let okAction = UIAlertAction(title: "OK", style: .cancel)
//                dialogMessage.addAction(okAction)
//                self.present(dialogMessage, animated: true)
//            }
//        }
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        let indexPath = IndexPath(row: textField.tag, section: 0)

        if indexPath.row == 0 {
            convertState = .uahToOtherCurrencies
            currencyRateModel.amount = Double(textField.text!) ?? 0
            tableView.reloadRows(
                at: (1..<currencyRateModel.popularCurrencies.count)
                    .map { IndexPath(row: $0, section: 0) },
                with: .none
            )
        } else {
            convertState = .chosenCurrencyToUah(rowNumber: indexPath.row)
            currencyRateModel.amount = Double(textField.text!) ?? 0
            let rowsForReload = (0..<currencyRateModel.popularCurrencies.count).filter {
                $0 != indexPath.row
            }
            tableView.reloadRows(
                at: rowsForReload.map { IndexPath(row: $0, section: 0) },
                with: .none)
        }
    }

    private func uahToOtherCurrency(_ amount: Double, _ sellBuyRate: Decimal) -> Decimal {
        return Decimal(amount) / sellBuyRate
    }

    private func currencyToUah(_ amount: Double, _ sellBuyRate: Decimal) -> Decimal {
        return Decimal(amount) * sellBuyRate
    }

    @IBAction func addCurrencyAction(_ sender: UIButton) {
        guard let viewController = storyboard?.instantiateViewController(identifier: "currencyList", creator: { coder in
            return CurrencyListViewController(
                coder: coder,
                sections: self.currencyRateModel.allCurrenciesInSections,
                delegate: self
            )
        }) else {
            fatalError("Failed to load CurrencyListViewController from storyboard.")
        }

        navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func changeCurrencyBuySell(_ sender: UISegmentedControl) {
    }
}

extension ViewController: CurrencySendingDelegate {
    func sendCurrency(currency: CurrencyRate) {
        currencyRateModel.popularCurrencies.append(currency)
        tableView.reloadData()
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
            customCell.currencyTextField.tag = indexPath.row
            customCell.currencyTextField.keyboardType = .decimalPad
            customCell.currencyTextField.addTarget(
                self,
                action: #selector(textFieldDidChange(_:)),
                for: .editingChanged
            )

            switch convertState {
            case .withoutConvert:
                customCell.currencyTextField.text = ""
            case .uahToOtherCurrencies:
                if indexPath.row == 0 {
                    customCell.currencyTextField.text = String(currencyRateModel.amount)
                } else {
                    let res = Decimal(currencyRateModel.amount) /
                    currencyRateModel.popularCurrencies[indexPath.row].sale

                    customCell.currencyTextField.text = String(format: "%.2f", Double(truncating: res as NSNumber))
                }
            case .chosenCurrencyToUah(let rowNumber):
                if indexPath.row == 0 {
                    let res = Decimal(currencyRateModel.amount) * currencyRateModel.popularCurrencies[rowNumber].sale
                    customCell.currencyTextField.text = String(format: "%.2f", Double(truncating: res as NSNumber))

                } else if indexPath.row == rowNumber {
                    customCell.currencyTextField.text = String(currencyRateModel.amount)
                } else {
                    customCell.currencyTextField.text = ""
                }
            }

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
