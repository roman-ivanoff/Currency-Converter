//
//  UILabel+Functional.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 18.09.2022.
//

import UIKit

extension UILabel {

    func setLineHeight(lineHeight: CGFloat) {
        guard let text = self.text else { return }

        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()

        style.lineSpacing = lineHeight
        attributeString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: style,
            range: NSMakeRange(0, attributeString.length))

        self.attributedText = attributeString
    }

}
