//
//  UINavigationBar+Configuration.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 03.11.2022.
//

import UIKit

extension UINavigationBar {
    func setShadowHidden(_ hidden: Bool) {
        setValue(hidden, forKey: "hidesShadow")
    }
}
