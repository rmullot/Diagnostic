//
//  DiagnosticTests.swift
//  DiagnosticTests
//
//  Created by Romain Mullot on 08/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import XCTest
@testable import Diagnostic

class SignInViewModelTests: XCTestCase {

  private var viewModel: SignInViewModel!

  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    viewModel = SignInViewModel()
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func test_email_is_empty() {
    XCTAssertFalse(viewModel.isEmailValid)
  }

  func test_email_is_invalid() {
    viewModel.setEmail("qwerty")
    XCTAssertFalse(viewModel.isEmailValid)
    viewModel.setEmail("qwerty@")
    XCTAssertFalse(viewModel.isEmailValid)
    viewModel.setEmail("qwerty@querty")
    XCTAssertFalse(viewModel.isEmailValid)
    viewModel.setEmail("123")
    XCTAssertFalse(viewModel.isEmailValid)
    viewModel.setEmail("qwertyquerty.fr")
    XCTAssertFalse(viewModel.isEmailValid)
    viewModel.setEmail("qwertyquerty.")
    XCTAssertFalse(viewModel.isEmailValid)
    viewModel.setEmail("qwerty@querty.")
    XCTAssertFalse(viewModel.isEmailValid)
  }

  func test_email_is_valid() {
    viewModel.setEmail("qwerty@querty.fr")
    XCTAssertTrue(viewModel.isEmailValid)
  }

  func test_password_is_empty() {
    XCTAssertFalse(viewModel.isPasswordValid)
  }

  func test_passwordRegex_is_invalid() {
    viewModel.setPassword("123")
    XCTAssertFalse(viewModel.password.isPasswordValid)
    viewModel.setPassword("123aafafafasfas")
    XCTAssertFalse(viewModel.password.isPasswordValid)
    viewModel.setPassword("PASSW0RD")
    XCTAssertFalse(viewModel.password.isPasswordValid)
  }

  func test_passwordRegex_is_valid() {
    viewModel.setPassword("Passw0rd")
    XCTAssertTrue(viewModel.password.isPasswordValid)
  }

  func test_password_is_too_short() {
    viewModel.setPassword("123")
    XCTAssertFalse(viewModel.isPasswordValid)
  }

  func test_password_is_enough_long() {
    viewModel.setPassword("12345678")
    XCTAssertTrue(viewModel.isPasswordEnoughStrong)
  }

  func test_sign_in_event_available() {
    viewModel.setPassword("12345678")
    viewModel.setEmail("qwerty@querty.fr")
    XCTAssertTrue(viewModel.isValid)
  }

  func test_sign_in_event_disable() {
    viewModel.setPassword("123456")
    viewModel.setEmail("qwerty@querty.fr")
    XCTAssertFalse(viewModel.isValid)
    viewModel.setPassword("")
    XCTAssertFalse(viewModel.isValid)
    viewModel.setPassword("12345678")
    viewModel.setEmail("qwerty@quertyfr")
    XCTAssertFalse(viewModel.isValid)
    viewModel.setEmail("qwertyquerty.fr")
    XCTAssertFalse(viewModel.isValid)
    viewModel.setEmail("qwertyquertyfr")
    XCTAssertFalse(viewModel.isValid)
    viewModel.setEmail("")
    XCTAssertFalse(viewModel.isValid)

  }

  func test_errorMessageInvalidPassword() {
      viewModel.setPassword("12345678", endEditing: true)
      viewModel.setEmail("asd@fsf.fr", endEditing: true)
      viewModel.signInEvent()
      XCTAssertEqual(viewModel.errorMessage, "Votre mot de passe est erroné.")
  }

  func test_errorMessageTooShortPassword() {
    viewModel.setPassword("fsf", endEditing: true)
    XCTAssertEqual(viewModel.errorMessage, "Votre mot de passe doit être d'au moins 8 charactères.")
  }

  func test_errorMessageInvalidSignInForm() {
    viewModel.setPassword("asd", endEditing: true)
    viewModel.setEmail("asd@fsfq.fr", endEditing: true)
    viewModel.signInEvent()
    XCTAssertEqual(viewModel.errorMessage, "Combinaison invalide.")
  }

  func test_errorMessageInvalidEmail() {
    viewModel.setEmail("asd@fsf", endEditing: true)
    XCTAssertEqual(viewModel.errorMessage, "Votre adresse email est erronée.")
  }

  func test_errorMessageMandatoryEmail() {
    viewModel.setEmail("", endEditing: true)
    XCTAssertEqual(viewModel.errorMessage, "Le champ adresse email est obligatoire.")
  }

  func test_errorMessageMandatoryPassword() {
    viewModel.setPassword("", endEditing: true)
    XCTAssertEqual(viewModel.errorMessage, "Le champ mot de passe est obligatoire.")
  }

}
