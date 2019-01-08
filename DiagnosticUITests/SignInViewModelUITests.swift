//
//  DiagnosticUITests.swift
//  DiagnosticUITests
//
//  Created by Romain Mullot on 08/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import XCTest

class SignInViewModelUITests: XCTestCase {

    private var app: XCUIApplication!
    private var scrollView: XCUIElement!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test.
        // Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation
        // - required for your tests before they run. The setUp method is a good place to do this.
        XCUIApplication.accessibilityActivate()

        app = XCUIApplication()
        XCTAssertTrue(app.scrollViews[UITestingIdentifiers.signInForm.rawValue].exists)
        scrollView = app.scrollViews[UITestingIdentifiers.signInForm.rawValue]
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_sign_in_button_event() {
        let button = scrollView.buttons[UITestingIdentifiers.signInButton.rawValue]
        XCTAssertTrue(scrollView.buttons[UITestingIdentifiers.signInButton.rawValue].exists)
        XCTAssertTrue(scrollView.textFields[UITestingIdentifiers.signInEmailField.rawValue].exists)
        XCTAssertTrue(scrollView.secureTextFields[UITestingIdentifiers.signInPasswordField.rawValue].exists)
        let emailField = scrollView.textFields[UITestingIdentifiers.signInEmailField.rawValue]
        emailField.tap()
        emailField.typeText("romain@mullot.fr")
        let passwordField = scrollView.secureTextFields[UITestingIdentifiers.signInPasswordField.rawValue]
        passwordField.tap()
        passwordField.typeText("Passw0rd")
        button.tap()
        XCTAssertTrue(app.buttons[UITestingIdentifiers.cameraButton.rawValue].exists)
    }
}
