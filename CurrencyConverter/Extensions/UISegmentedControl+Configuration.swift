//
//  UISegmentedControl+Configuration.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 21.10.2022.
//

import UIKit

extension UISegmentedControl {
    func removeBorders() {
        setBackgroundImage(UIImage.imageWithColor(color: backgroundColor ?? .clear), for: .normal, barMetrics: .default)
        setBackgroundImage(UIImage.imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
        setDividerImage(
            UIImage.imageWithColor(color: UIColor.clear),
            forLeftSegmentState: .normal,
            rightSegmentState: .normal,
            barMetrics: .default
        )
    }
}
