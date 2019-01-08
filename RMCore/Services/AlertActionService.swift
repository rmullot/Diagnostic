//
//  AlertActionService.swift
//  RMCore
//
//  Created by Romain Mullot on 16/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation
import UIKit

protocol AlertActionServiceProtocol {
  func showAlertWith(title: String, message: String)
  func showSheetWith(actions: [AlertAction], title: String, message: String)
}

public final class AlertActionService: AlertActionServiceProtocol {

  // MARK: - Attributes

  public static let sharedInstance = AlertActionService()

  private var navigationController: UINavigationController {
    guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
        return UINavigationController()
    }
    return navigationController
  }

  // MARK: - Methods

  public func showAlertWith(title: String, message: String) {
    guard let visibleViewController = self.navigationController.visibleViewController else { return }
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: ConstantsCore.okTitle, style: .cancel) { _ in
        visibleViewController.dismiss(animated: true, completion: nil)
    }
    alertController.addAction(action)
    visibleViewController.present(alertController, animated: true, completion: nil)

  }

  public func showSheetWith(actions: [AlertAction], title: String, message: String) {
    guard let visibleViewController = self.navigationController.visibleViewController else { return }
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    actions.forEach { action in
        var style: UIAlertAction.Style
        switch action.type {
        case .default:
            style = .default
        case .cancel:
            style = .cancel
        case .warning:
            style = .destructive
        case .checked:
            style = .default
        }

        let newAlertAction = UIAlertAction(title: action.title, style: style) { _ in
            action.action?()
        }

        if action.type == .checked {
            newAlertAction.setValue(true, forKey: "checked")
        }

        alertController.addAction(newAlertAction)
    }
    visibleViewController.present(alertController, animated: true, completion: nil)

  }

  // MARK: - Private Methods

  private init() {}

}

public struct AlertAction {

  public init(title: String, type: AlertActionType = .default, action: (() -> Void)? = nil) {
    self.title = title
    self.type = type
    self.action = action
  }
  public var action: (() -> Void)?

  public var title: String

  public var type: AlertActionType
}

public enum AlertActionType: Int {
  case `default` = 0
  case cancel = 1
  case warning = 2
  case checked = 3
}
