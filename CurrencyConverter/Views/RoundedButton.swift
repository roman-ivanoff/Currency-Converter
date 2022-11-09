//
//  RoundedButton.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 08.11.2022.
//

import UIKit

class RoundedButton: UIButton {

    required init?(coder: NSCoder) {
            super.init(coder: coder)
            setup()
        }

    private func setup() {
        layer.borderWidth = 1
        layer.cornerRadius = 10
        layer.borderColor = UIColor(named: "buttonColor")?.cgColor
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
           if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
               layer.borderColor = UIColor(named: "buttonColor")?.cgColor
           }
       }
    }
}
