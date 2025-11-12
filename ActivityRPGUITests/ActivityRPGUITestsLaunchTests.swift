//
//  ActivityRPGUITestsLaunchTests.swift
//  ActivityRPGUITests
//
//  Created by Vladislav Bystritskii on 08/11/2025.
//

import XCTest

final class ActivityRPGUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
