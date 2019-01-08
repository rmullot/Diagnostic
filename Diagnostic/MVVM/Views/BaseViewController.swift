//
//  BaseViewController.swift
//  Diagnostic
//
//  Created by Romain Mullot on 09/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import UIKit

import Foundation

class BaseViewController<T: BaseViewModel> : UIViewController {

    private var didHideKeyboardObserver: NSObjectProtocol!
    private var didShowKeyboardObserver: NSObjectProtocol!
    private var keyboardNotificationsRegistered: Bool = false
    private var hideKeyboardGestureRecognizer: UITapGestureRecognizer!
    private var willHideKeyboardObserver: NSObjectProtocol!
    private var willShowKeyboardObserver: NSObjectProtocol!

    // MARK: - Initialization & Memory Management

    deinit {
        print("\(self)")
    }

    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      startListeningKeyboardNotifications()
      touchBackgroundHidesKeyboard = true
    }

    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      dismissKeyboard()
      stopListeningKeyboardNotifications()
    }

    // MARK: - Properties

    var isKeyboardHidden: Bool {
      return !isKeyboardVisible
    }

    private(set) var isKeyboardVisible: Bool = false

    var isPhone: Bool {
      return UIDevice.current.userInterfaceIdiom == .phone
    }

    var isTablet: Bool {
      return UIDevice.current.userInterfaceIdiom == .pad
    }

     var touchBackgroundHidesKeyboard = false {
      didSet {
          guard touchBackgroundHidesKeyboard != oldValue else { return }
          if touchBackgroundHidesKeyboard {
              hideKeyboardGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
              hideKeyboardGestureRecognizer.cancelsTouchesInView = false
              view.addGestureRecognizer(hideKeyboardGestureRecognizer)
          } else {
              guard hideKeyboardGestureRecognizer != nil else { return }
              view.removeGestureRecognizer(hideKeyboardGestureRecognizer)
              hideKeyboardGestureRecognizer = nil
          }
      }
    }

    var viewModel = T()

    // MARK: - Methods

    @objc func dismissKeyboard() {
      view.endEditing(true)
    }

    func keyboardWillHide(_ keyboardSize: CGSize) {}

    func keyboardWillShow(_ keyboardSize: CGSize) {}

    func keyboardDidHide(_ keyboardSize: CGSize) {}

    func keyboardDidShow(_ keyboardSize: CGSize) {}

    func startListeningKeyboardNotifications() {
      guard !keyboardNotificationsRegistered else { return }
      keyboardNotificationsRegistered = true
      didHideKeyboardObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: nil) { [unowned self] notification in
          self.isKeyboardVisible = false
          self.keyboardDidHide(self.getKeyboardSize(notification))
      }
      didShowKeyboardObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: nil) { [unowned self] notification in
          self.isKeyboardVisible = true
          self.keyboardDidShow(self.getKeyboardSize(notification))
      }
      willHideKeyboardObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [unowned self] notification in
          self.keyboardWillHide(self.getKeyboardSize(notification))
      }
      willShowKeyboardObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [unowned self] notification in
          self.keyboardWillShow(self.getKeyboardSize(notification))
      }
    }

     func stopListeningKeyboardNotifications() {
      guard keyboardNotificationsRegistered else { return }
      NotificationCenter.default.removeObserver(didHideKeyboardObserver)
      NotificationCenter.default.removeObserver(didShowKeyboardObserver)
      NotificationCenter.default.removeObserver(willHideKeyboardObserver)
      NotificationCenter.default.removeObserver(willShowKeyboardObserver)
      keyboardNotificationsRegistered = false
    }

    // MARK: - Private Methods

    private func getKeyboardSize(_ notification: Notification) -> CGSize {
      guard let value = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return .zero }
      return value.cgRectValue.size
    }

}
