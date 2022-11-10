//
//  CurrencyConverterUITests.swift
//  CurrencyConverterUITests
//
//  Created by Roman Ivanov on 10.11.2022.
//

import XCTest
@testable import CurrencyConverter

class CurrencyConverterUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["mock"]
        app.launch()
    }

    func testUIViewsExist() {
        XCTAssertTrue(app.staticTexts["currencyConverterLabel"].exists)
        XCTAssertTrue(app.tables.firstMatch.exists)
        XCTAssertTrue(app.segmentedControls.firstMatch.exists)
        XCTAssertTrue(app.buttons["shareButton"].exists)
        XCTAssertTrue(app.buttons["addCurrencyButton"].exists)
        XCTAssertTrue(app.buttons["nationalBankButton"].exists)
        XCTAssertTrue(app.staticTexts["lastUpdatedTextLabel"].exists)
        XCTAssertTrue(app.staticTexts["lastUpdatedDateLabel"].exists)
    }

    func testOpenCurrencyListScreen() {
        app.buttons["addCurrencyButton"].tap()
        XCTAssertTrue(app.navigationBars["Currency"].exists)
        XCTAssertTrue(app.tables.firstMatch.exists)
    }

    func testReturnToFirstVC() {
        app.buttons["addCurrencyButton"].tap()
        app.navigationBars["Currency"].buttons.firstMatch.tap()
        testUIViewsExist()
    }

    func testDatePickerAppears() {
        app.buttons["nationalBankButton"].tap()
        XCTAssertTrue(app.datePickers["datePicker"].exists)
    }

    func testDatePickerHides() {
        app.buttons["nationalBankButton"].tap()
        app.alerts["\n\n\n\n\n\n\n\n"].scrollViews.otherElements.buttons["Cancel"].tap()
        XCTAssertFalse(app.datePickers["datePicker"].exists)
        testUIViewsExist()
    }
}
