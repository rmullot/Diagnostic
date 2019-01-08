//
//  LocalhostServerService.swift
//  Diagnostic
//
//  Created by Romain Mullot on 14/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation
import RMCore
import SwiftMessages

enum ParserError: Error {
  case decodeObject
  case diagnosticNotFound
  case noNetwork
  case photoNotFound
  case unknownObject
}

typealias LocalhostServerCompletionHandler = (String, ParserError?) -> Void

protocol LocalhostServerServiceProtocol {
  func sendDiagnostic(diagnosticJSON: Data, completionHandler: @escaping LocalhostServerCompletionHandler)
}

final class LocalhostServerService: LocalhostServerServiceProtocol {

  static let sharedInstance = LocalhostServerService()

  // MARK: Properties

  private let urlLogin: String = ""
  var onlineMode: OnlineMode = .online
  private var receivedDiagnostic: Diagnostic = Diagnostic()
  private let fakeNetworkDuration = 2.0

  // MARK: - Methods

  private func createDiagnosticFeadback(receivedDiagnostic: Diagnostic?, completionHandler: @escaping LocalhostServerCompletionHandler) {

      let logSeparator = "\n\n###############\n\n"
      var diagnosticAvailable = false
      var photoNotAvailable = true
      var log = logSeparator

      if let startTime = receivedDiagnostic?.startTime, let endTime = receivedDiagnostic?.endTime {
          log.append("startTime:\(startTime)\nendTime:\(endTime)\n")
      }

      if let photoTestData = receivedDiagnostic?.photoTestData {
          diagnosticAvailable = true
          log.append(Constants.logReceivedPhotoDiagnostic)
          if let photoBase64 = photoTestData.photo, let image = photoBase64.decodePhoto(), let sizeString = image.pngData()?.toBytesString() {
              log.append(String(format: Constants.logSizePhoto, sizeString))
              photoNotAvailable = false
          } else {
              log.append(Constants.logFailPhotoDiagnostic)
          }
          log.append("\n\n")
      } else {
          log.append(Constants.logUnavailablePhotoDiagnostic)
      }

      if receivedDiagnostic?.gpsTestData != nil {
        diagnosticAvailable = true
      } else {
         log.append(Constants.logUnavailableGPSDiagnostic)
      }

      if receivedDiagnostic?.touchScreenTestData != nil {
        diagnosticAvailable = true
      } else {
        log.append(Constants.logUnavailableTouchScreenDiagnostic)
      }

      if !diagnosticAvailable || receivedDiagnostic == nil {
        log.append(Constants.logUnavailableAllDiagnostics)
        completionHandler(log, .diagnosticNotFound)
        return
      }
      guard photoNotAvailable == false else { completionHandler(log, .photoNotFound)
          return
      }
      log.append(logSeparator)
      completionHandler(log, nil)
  }

  func sendDiagnostic(diagnosticJSON: Data, completionHandler: @escaping LocalhostServerCompletionHandler) {
    guard onlineMode != .offline else {
      AlertActionService.sharedInstance.showAlertWith(title: Constants.errorTitle, message: Constants.errorUnavailableNetwork)
      completionHandler(Constants.errorUnavailableNetwork, .noNetwork)
      return
    }
    NetworkActivityService.sharedInstance.newRequestStarted()
    let delayWorkItem = DispatchWorkItem(block: { [unowned self] in  defer {
        NetworkActivityService.sharedInstance.requestFinished()
        }
        var logError = ""
        var parserError: ParserError?
        do {
            let receivedDiagnostic: Diagnostic? = try JSONDecoder().decode(Diagnostic.self, from: diagnosticJSON)
            self.createDiagnosticFeadback(receivedDiagnostic: receivedDiagnostic) { log, error in
                DispatchQueue.main.async {
                    completionHandler(log, error)
                }
            }

        } catch DecodingError.dataCorrupted(let context) {
          logError = "\(context)"
          parserError = ParserError.decodeObject
        } catch DecodingError.keyNotFound(let key, let context) {
          logError = "\nKey '\(key)' not found: \(context.debugDescription)\ncodingPath: \(context.codingPath)"
          parserError = ParserError.decodeObject
        } catch DecodingError.valueNotFound(let value, let context) {
          logError = "\nValue '\(value)' not found: \(context.debugDescription)\ncodingPath: \(context.codingPath)"
          parserError = ParserError.decodeObject
        } catch DecodingError.typeMismatch(let type, let context) {
          logError = "\nType '\(type)' mismatch: \(context.debugDescription)\n\ncodingPath: \(context.codingPath)"
          parserError = ParserError.decodeObject
        } catch {
          logError = "\nerror: \(error)"
          parserError = ParserError.unknownObject
        }
        if let parserError = parserError {
          DispatchQueue.main.async {
              completionHandler(logError, parserError)
          }
        }
    })

    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + fakeNetworkDuration, execute: delayWorkItem)

  }

  func displayNetworkStatus() {
    let view = MessageView.viewFromNib(layout: .cardView)
    switch onlineMode {
    case .offline:
    view.configureTheme(.warning)
    view.configureContent(title: Constants.errorTitle, body: Constants.errorUnavailableNetwork)
    case .onlineSlow:
    view.configureTheme(.warning)
    view.configureContent(title: Constants.errorTitle, body: Constants.badNetworkMessage)
    case .online:
    view.configureTheme(.success)
    view.configureContent(title: Constants.okTitle, body: Constants.networkAvailableMessage)
    }
    SwiftMessages.show {
      view.configureDropShadow()
      view.button?.isHidden = true
      view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
      (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
      return view
    }
  }

  // MARK: - Private Methods

  private init() {
      ReachabilityService.sharedInstance.delegates.add(self)
  }

  deinit {
      ReachabilityService.sharedInstance.delegates.remove(self)
  }

}

// MARK: - ReachabilityManagerDelegate
extension LocalhostServerService: ReachabilityServiceDelegate {

  func onlineModeChanged(_ newMode: OnlineMode) {
      if onlineMode != newMode {
          onlineMode = newMode
          displayNetworkStatus()
      }
  }

}
