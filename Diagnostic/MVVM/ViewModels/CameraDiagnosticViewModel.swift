//
//  CameraDiagnosticViewModel.swift
//  Diagnostic
//
//  Created by Romain Mullot on 11/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation
import RMCore

final class CameraDiagnosticViewModel: BaseViewModel {

    enum PropertyNames: String {
      case titleMessage
    }

    private(set)var titleMessage: String = "" {
      didSet {
          propertyChanged?(PropertyNames.titleMessage.rawValue)
      }
    }

    var lampActivated: Bool = false

    func toggleLamp() -> Bool {
      lampActivated = !lampActivated
      let available = CameraService.toggleTorch(isOn: lampActivated)
      if !available {
          errorMessage = L10n.errorLampUnavailable
      }
      return available
    }

    func askPermissionForCamera(completionHandler:@escaping (Bool) -> Void) {
      PermissionService.askPermissionForCamera { (granted) in
          completionHandler(granted)
      }
    }

    func finishDiagnostic(photoBase64: String) {
      titleMessage = L10n.isThisPhotoIsGoodTitle
      var actions = [AlertAction]()
      let yesAction = AlertAction(title: L10n.yesTitle, type: .default) {
          DiagnosticService.sharedInstance.setTimer(Date(), isLaunched: false)
          DiagnosticService.sharedInstance.setPhotoPrint(photoBase64: photoBase64)
          NavigationService.sharedInstance.navigateToResultDiagnostic()
      }
      let noAction = AlertAction(title: L10n.noTitle, type: .default) {
          DiagnosticService.sharedInstance.setTimer(Date(), isLaunched: false)
          DiagnosticService.sharedInstance.setPhotoPrint(photoBase64: "")
          NavigationService.sharedInstance.navigateToResultDiagnostic()
      }

      actions.append(yesAction)
      actions.append(noAction)
      AlertActionService.sharedInstance.showSheetWith(actions: actions, title: titleMessage, message: "")
    }

    func forceSwitchOffLamp() {
      lampActivated = false
      CameraService.toggleTorch(isOn: lampActivated)
    }

    func rebootStatusMessage() {
      errorMessage = ""
    }

}
