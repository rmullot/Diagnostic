//
//  ResultDiagnosticViewModel.swift
//  Diagnostic
//
//  Created by Romain Mullot on 13/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation

final class ResultDiagnosticViewModel: BaseViewModel {

    enum PropertyNames: String {
      case log
      case readyToSend
    }

    private var diagnosticJSON: Data = Data()

    private(set)var log: String = "" {
      didSet {
          propertyChanged?(PropertyNames.log.rawValue)
      }
    }

    var isSendingDiagnosticAvailable: Bool {
      guard LocalhostServerService.sharedInstance.onlineMode != .offline else {
        LocalhostServerService.sharedInstance.displayNetworkStatus()
        return false
      }
      return true
    }

    func loadDiagnostic() {
      DiagnosticService.sharedInstance.getDiagnosticJSON { diagnostic in
        self.diagnosticJSON = diagnostic
        let infos = L10n.logDiagnosticReadyToSend(diagnostic.toBytesString())
        self.propertyChanged?(PropertyNames.readyToSend.rawValue)
        self.log = infos
      }
    }

    func sendDiagnostic() {
      LocalhostServerService.sharedInstance.sendDiagnostic(diagnosticJSON: diagnosticJSON) { feedBackServer, _ in
        self.log = feedBackServer
        self.propertyChanged?(PropertyNames.readyToSend.rawValue)
      }
    }

    func newDiagnostic() {
      DiagnosticService.sharedInstance.rebootDiagnostic()
      NavigationService.sharedInstance.navigateToNewDiagnostic()
    }

}
