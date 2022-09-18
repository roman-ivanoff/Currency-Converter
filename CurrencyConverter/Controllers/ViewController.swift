//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 12.09.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var firstEllipse: UIView!
    @IBOutlet weak var converterView: UIView!
    @IBOutlet weak var lastUpdatedDateLabel: UILabel!
    @IBOutlet weak var lastUpdatedTextLabel: UILabel!

    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var sellButton: UIButton!
    var isSell = true
    var isBuy = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setConverterView()
    }

    private func setConverterView() {
        converterView.layer.cornerRadius = 10

        converterView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        converterView.layer.shadowOpacity = 1
        converterView.layer.shadowRadius = 4
        converterView.layer.shadowOffset = CGSize(width: 0, height: 4)

        lastUpdatedTextLabel.setLineHeight(lineHeight: 1.46)
        lastUpdatedDateLabel.setLineHeight(lineHeight: 1.46)
    }
    
    @IBAction func sellAction(_ sender: UIButton) {
    }
    @IBAction func buyAction(_ sender: UIButton) {
    }
}

