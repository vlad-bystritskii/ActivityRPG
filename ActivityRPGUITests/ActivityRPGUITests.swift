//
//  ActivityRPGUITests.swift
//  ActivityRPGUITests
//
//  Created by Vladislav Bystritskii on 08/11/2025.
//

import XCTest

final class ActivityRPGUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    @MainActor
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
