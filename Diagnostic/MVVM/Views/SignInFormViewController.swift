//
//  SignInFormViewController.swift
//  Diagnostic
//
//  Created by Romain Mullot on 08/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import UIKit
import RMUI

final class SignInFormViewController: BaseViewController<SignInViewModel> {

  // MARK: - IBOutlets

  @IBOutlet weak var errorLabel: UILabel!
  @IBOutlet weak var emailTextField: RMTextField!
  @IBOutlet weak var passwordTextField: RMTextField!
  @IBOutlet weak var signInButton: RMButton!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var scrollBottomConstraint: NSLayoutConstraint!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    scrollView.accessibilityIdentifier = UITestingIdentifiers.signInForm.rawValue
    emailTextField.keyboardType = .emailAddress
    emailTextField.accessibilityIdentifier = UITestingIdentifiers.signInEmailField.rawValue
    passwordTextField.keyboardType = .default
    passwordTextField.isSecureTextEntry = true
    passwordTextField.accessibilityIdentifier = UITestingIdentifiers.signInPasswordField.rawValue
    signInButton.accessibilityIdentifier = UITestingIdentifiers.signInButton.rawValue
    setupTextField(emailTextField)
    setupTextField(passwordTextField)
    viewModel.propertyChanged = { [weak self] name in self?.viewModelPropertyChanged(name) }
  }

 // MARK: - IBActions

  @IBAction func signInTouchUpInside(_ sender: UIButton) {
    viewModel.signInEvent()
  }

  // MARK: - Keyboard Methods

  override func keyboardWillHide(_ keyboardSize: CGSize) {
      scrollBottomConstraint.constant = 0
      UIView.animate(withDuration: Constants.defaultAnimationDuration) {
          self.view.layoutIfNeeded()
      }
  }

  override func keyboardWillShow(_ keyboardSize: CGSize) {
    guard isKeyboardHidden else { return }
    // If the form is hidden by the keyboard we need to scroll to help the user
    if  UIScreen.main.bounds.height - keyboardSize.height < signInButton.frame.maxY {
        scrollBottomConstraint.constant = keyboardSize.height
        var point = emailTextField.convert(emailTextField.frame.origin, to: scrollView)
        point.x = 0
        point.y -= emailTextField.frame.height / 2
        scrollView.setContentOffset(point, animated: true)
    }
    UIView.animate(withDuration: Constants.defaultAnimationDuration) {
        self.view.layoutIfNeeded()
    }
  }

  // MARK: - Private Methods

  // Method permitting to modify in real-time the values inside the viewModel
  private func processTextFieldEditing(_ textField: RMTextField, text: String, endEditing: Bool) {
    switch textField {
    case emailTextField:
        viewModel.setEmail(text, endEditing: endEditing)
    case passwordTextField:
        viewModel.setPassword(text, endEditing: endEditing)
    default:
        break
    }
  }

  // Method permitting to modify the texfield if the text is validated or not
  private func processTextFieldValidation(_ textField: RMTextField, isValid: Bool) {
      isValid ? textField.setValidState() : textField.setInvalidState()
  }

  // Method to setup the callbacks between the interface and the textField
  private func setupTextField(_ textField: RMTextField) {
    textField.didEndEditing = { [unowned self] text in
        self.processTextFieldEditing(textField, text: text, endEditing: true)
    }
    textField.textDidChange = { [unowned self] text in
        self.processTextFieldEditing(textField, text: text, endEditing: false)
    }
  }

  private func viewModelPropertyChanged(_ name: String) {
    switch name {
    case SignInViewModel.PropertyNames.isEmailValid.rawValue:
        processTextFieldValidation(emailTextField, isValid: viewModel.isEmailValid)
        signInButton.isEnabled = viewModel.isValid
    case SignInViewModel.PropertyNames.isPasswordEnoughStrong.rawValue:
        processTextFieldValidation(passwordTextField, isValid: viewModel.isPasswordEnoughStrong)
        signInButton.isEnabled = viewModel.isValid
    case SignInViewModel.PropertyNames.errorMessage.rawValue:
        if viewModel.errorMessage.isNotEmpty {
            errorLabel.text = viewModel.errorMessage
        }
    case SignInViewModel.PropertyNames.signInInValid.rawValue:
        processTextFieldValidation(emailTextField, isValid: viewModel.isEmailValid)
        processTextFieldValidation(passwordTextField, isValid: viewModel.isPasswordValid)
    case SignInViewModel.PropertyNames.isValid.rawValue:
         errorLabel.text = ""
    default:
        break
    }
  }

}
