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

    var sections: [Section]
    var delegate: CurrencySendingDelegate?

    init?(coder: NSCoder, sections: [Section], delegate: CurrencySendingDelegate) {
        self.sections = sections
        self.delegate = delegate
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

        delegate?.sendCurrency(currency: sections[indexPath.section].sectionObjects[indexPath.row])

        dismiss(animated: true) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
