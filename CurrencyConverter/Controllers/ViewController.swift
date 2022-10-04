//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 12.09.2022.
//

import UIKit

// swiftlint: disable: force_cast
class ViewController: UIViewController {
    @IBOutlet weak var firstEllipse: UIView!
    @IBOutlet weak var converterView: UIView!
    @IBOutlet weak var lastUpdatedDateLabel: UILabel!
    @IBOutlet weak var lastUpdatedTextLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var eurCurrencyView: CurrencyItem!
    @IBOutlet weak var usdCurrencyView: CurrencyItem!
    @IBOutlet weak var uahCurrencyView: CurrencyItem!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var addCurrencyButton: UIButton!

    let repository = RatesRepository(
        localDataSource: RatesLocalDataSource(),
        remoteDataSource: RatesRemoteDataSource()
    )

    var isSell = true
    var isBuy = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setConverterView()

        repository.fetchRates { result in
            switch result {
            case .success(let res):
                print(res)
            case .failure(let error):
                print(error)
            }
        }
    }

    private func setConverterView() {
        converterView.layer.cornerRadius = 10

        converterView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        converterView.layer.shadowOpacity = 1
        converterView.layer.shadowRadius = 4
        converterView.layer.shadowOffset = CGSize(width: 0, height: 4)

        lastUpdatedTextLabel.setLineHeight(lineHeight: 1.46)
        lastUpdatedDateLabel.setLineHeight(lineHeight: 1.46)

        sellButton.layer.cornerRadius = 6
        buyButton.layer.cornerRadius = 6

        eurCurrencyView.currencyLabel.text = "EUR"
        usdCurrencyView.currencyLabel.text = "USD"
    }

    private func changeButtonColorToBlue(_ btn: UIButton) {
        UIView.transition(
            with: self.view,
            duration: 0.5,
            options: .transitionCrossDissolve) {
                btn.backgroundColor = UIColor(named: "buttonColor")
                btn.setTitleColor(UIColor.white, for: .normal)
            }
    }

    private func changeButtonColorToWhite(_ btn: UIButton) {
        UIView.transition(
            with: self.view,
            duration: 0.5,
            options: .transitionCrossDissolve) {
                btn.backgroundColor = UIColor.white
                btn.setTitleColor(UIColor(named: "buttonTextColor"), for: .normal)
            }
    }

    @IBAction func sellAction(_ sender: UIButton) {
        isSell = true
        isBuy = false

        changeButtonColorToBlue(sellButton)
        changeButtonColorToWhite(buyButton)
    }

    @IBAction func buyAction(_ sender: UIButton) {
        isSell = false
        isBuy = true

        changeButtonColorToBlue(buyButton)
        changeButtonColorToWhite(sellButton)
    }

    @IBAction func shareAction(_ sender: Any) {
    }

    @IBAction func addCurrencyAction(_ sender: UIButton) {
    }
}
//
//extension ViewController {
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destController = segue.destination as! CurrencyListViewController
//        destController.currencyRate = currencyRateModel.sortRates()
//    }
//}
