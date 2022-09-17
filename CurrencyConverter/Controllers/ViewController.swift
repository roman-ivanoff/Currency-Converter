//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 12.09.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var firstEllipse: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        firstEllipse.clipsToBounds = true
        firstEllipse.layer.cornerRadius = 60
        firstEllipse.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }


}

