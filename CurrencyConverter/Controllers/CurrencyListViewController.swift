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
    var searchController: UISearchController!
    private var initialBottomInset: CGFloat = 0

    var isSearchBarEmpty: Bool {
        searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
        searchController.isActive && !isSearchBarEmpty
    }

    var sections: [Section]
    var filteredSections: [Section] = [Section]()
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
        tableView.keyboardDismissMode = .interactive
        navigationController?.title = "Currency"

        setupSearchController()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize =
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            initialBottomInset = tableView.contentInset.bottom
            let newBottomInset = keyboardSize.height - view.safeAreaInsets.bottom
            tableView.contentInset.bottom = newBottomInset
            tableView.verticalScrollIndicatorInsets.bottom = newBottomInset
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset.bottom = initialBottomInset
        tableView.verticalScrollIndicatorInsets.bottom = initialBottomInset
    }

    private func registerCell(for tableView: UITableView, id: String) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: id)
    }

    private func setupSearchController() {
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 16
        } else {
            tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        }

        searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Currency"
        searchController.searchBar.barTintColor = UIColor(named: "tableBacgroundColor")
        searchController.searchBar.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16,
            bottom: 0,
            trailing: 16
        )
        navigationController?.navigationBar.setShadowHidden(true)
        definesPresentationContext = true
    }
}

extension CurrencyListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }

    func filterContentForSearchText(_ searchText: String) {
        var currencyArray: [CurrencyRate] = []
        filteredSections.removeAll()

        for section in sections {
            if section.sectionName == NSLocalizedString("popular", comment: "") {
                continue
            }

            currencyArray = section.sectionObjects.filter {
                $0.currency.rawValue.lowercased().contains(searchText.lowercased())
            }

            if !currencyArray.isEmpty {
                filteredSections.append(Section(sectionName: section.sectionName, sectionObjects: currencyArray))
            }
        }

        tableView.reloadData()
    }

}

extension CurrencyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ?
        filteredSections[section].sectionObjects.count :
        sections[section].sectionObjects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let currency: CurrencyRate
        if isFiltering {
            currency = filteredSections[indexPath.section]
                .sectionObjects[indexPath.row]
        } else {
            currency = sections[indexPath.section]
                .sectionObjects[indexPath.row]
        }

        cell.textLabel?.text = currency.currency.rawValue

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return isFiltering ? filteredSections.count : sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isFiltering ? filteredSections[section].sectionName : sections[section].sectionName
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }

        let currency: CurrencyRate

        if isFiltering {
            currency = filteredSections[indexPath.section].sectionObjects[indexPath.row]
        } else {
            currency = sections[indexPath.section].sectionObjects[indexPath.row]
        }

        delegate?.sendCurrency(currency: currency)

        dismiss(animated: true) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
