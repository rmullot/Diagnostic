//
//  NavigationService.swift
//  Diagnostic
//
//  Created by Romain Mullot on 11/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation
import UIKit

protocol NavigationServiceProtocol {
    func navigateToCameraDiagnostic()
    func navigateToResultDiagnostic()
    func navigateToNewDiagnostic()
}

final class NavigationService: NavigationServiceProtocol {

    // MARK: - Attributes

    static let sharedInstance = NavigationService()

    private var navigationController: UINavigationController {
      guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
          fatalError()
      }
      return navigationController
    }

    // MARK: - Methods

    func navigateToCameraDiagnostic() {
      guard navigationController.visibleViewController is SignInFormViewController  else { return }
      if let cameraDiagnosticViewController = loadViewController("CameraDiagnosticViewController") as? CameraDiagnosticViewController {
          navigationController.pushViewController(cameraDiagnosticViewController, animated: true)
      }
    }

    func navigateToResultDiagnostic() {
      guard navigationController.visibleViewController is CameraDiagnosticViewController  else { return }
      if let resultDiagnosticViewController = loadViewController("ResultDiagnosticViewController") as? ResultDiagnosticViewController {
          navigationController.pushViewController(resultDiagnosticViewController, animated: true)
      }
    }

    func navigateToNewDiagnostic() {
      guard navigationController.visibleViewController is ResultDiagnosticViewController  else { return }
      navigationController.popToRootViewController(animated: true)
    }

    // MARK: - Private Methods

    private init() {}

    private func loadViewController(_ identifier: String) -> UIViewController {
      return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
}
