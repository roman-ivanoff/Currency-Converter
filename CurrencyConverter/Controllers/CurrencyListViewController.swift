//
//  CurrencyListViewController.swift
//  CurrencyConverter
//
//  Created by Roman Ivanov on 04.10.2022.
//

import UIKit

class CurrencyListViewController: UIViewController {
    let cellId = "Cell"
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchCurrencyTextField: DesignableUITextField!

    var sections: [Section]

    init?(coder: NSCoder, sections: [Section]) {
        self.sections = sections
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with sections.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.contentInset.top = 8

        registerCell(for: tableView, id: cellId)
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func registerCell(for tableView: UITableView, id: String) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: id)
    }
}

extension CurrencyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return currencyRate?.count ?? 0
        return sections[section].sectionObjects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = sections[indexPath.section]
            .sectionObjects[indexPath.row]
            .currency
            .rawValue

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].sectionName
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }

        let rateDict = ["rate": sections[indexPath.section].sectionObjects[indexPath.row]]

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addRate"), object: nil, userInfo: rateDict)

        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true)
    }
}
