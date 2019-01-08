//
//  SignInViewModel.swift
//  Diagnostic
//
//  Created by Romain Mullot on 09/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation

final class SignInViewModel: BaseViewModel {

    enum PropertyNames: String {
      case isEmailValid
      case isPasswordEnoughStrong
      case signInInValid
    }

    // MARK: - Private Members

    private let passWordMinCharacters = 8

    // MARK: - Public Variables

    private(set) var email: String = "" {
      didSet {
          UserService.sharedInstance.currentUser.email = email
          propertyChanged?(PropertyNames.isEmailValid.rawValue)
          validate()
      }
    }

    private(set) var password: String = "" {
      didSet {
          UserService.sharedInstance.currentUser.password = password
          propertyChanged?(PropertyNames.isPasswordEnoughStrong.rawValue)
          validate()
      }
    }

    func setEmail(_ email: String, endEditing: Bool = false) {
      self.email = email
      if endEditing {
          guard email.isNotEmpty else {
              errorMessage = Constants.errorMessageMandatoryEmail
              return
          }
          guard isEmailValid else {
              errorMessage = Constants.errorMessageInvalidEmail
              return
          }
      }
    }

    func setPassword(_ password: String, endEditing: Bool = false) {
      self.password = password
      if endEditing {
          guard password.isNotEmpty else {
              errorMessage = Constants.errorMessageMandatoryPassword
              return
          }
          guard isPasswordEnoughStrong else {
              errorMessage = Constants.errorMessageTooShortPassword
              return
          }
      }
    }

    var isEmailValid: Bool {
      return email.isEmail
    }

    var isPasswordEnoughStrong: Bool {
      return password.count >= passWordMinCharacters
    }

    var isPasswordValid: Bool {
      return password.isPasswordValid
    }

    override var isValid: Bool {
      return isEmailValid && isPasswordEnoughStrong
    }

    func signInEvent() {
      guard isValid else {
          errorMessage = Constants.errorMessageInvalidSignInForm
          propertyChanged?(PropertyNames.signInInValid.rawValue)
          return
      }
      guard isPasswordValid else {
          errorMessage = Constants.errorMessageInvalidPassword
          propertyChanged?(PropertyNames.signInInValid.rawValue)
          return
      }
      DiagnosticService.sharedInstance.setTimer(Date(), isLaunched: true)
      NavigationService.sharedInstance.navigateToCameraDiagnostic()
    }
}
