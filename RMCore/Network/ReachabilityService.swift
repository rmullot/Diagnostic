//
//  ReachabilityService.swift
//  RMCore
//
//  Created by Romain Mullot on 14/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation
import CoreTelephony
import UIKit
import Reachability

// MARK: - OnlineMode

public enum OnlineMode: Int {
    case offline = 0
    case onlineSlow = 1
    case online = 2
}

// MARK: - Reachability Manager Delegate

public protocol ReachabilityServiceDelegate: class {
    var onlineMode: OnlineMode {get}
    func onlineModeChanged(_ onlineMode: OnlineMode)
}

// MARK: - ReachabilityService

public final class ReachabilityService {

  // MARK: Properties

  public static let sharedInstance = ReachabilityService()

  public private(set) var delegates = MulticastDelegate<ReachabilityServiceDelegate>()

  private var reachability: Reachability?

  private let telephonyInfo = CTTelephonyNetworkInfo()

  private var _onlineMode: OnlineMode = .online

  private(set) var onlineMode: OnlineMode {
      set {
          _onlineMode = newValue
          self.delegates.invoke { (delegate) in
              delegate.onlineModeChanged(_onlineMode)
          }
      }

      get {
          return _onlineMode
      }
  }

  private let changeOperatingModeDelay: Double = 2.0 //in seconds

  private var changeOperatinModeClosure: DispatchQueue.CancellableClosure?

  private init() {
      self.delegates = MulticastDelegate<ReachabilityServiceDelegate>.init(addClosure: {delegate in
          delegate.onlineModeChanged(self.onlineMode)
      })
      self.onlineMode = .online
      reachability = Reachability()
      if reachability != nil {
          do {
              NotificationCenter.default.addObserver(self,
                                                     selector: #selector(ReachabilityService.reachabilityChanged(_:)),
                                                     name: Notification.Name.reachabilityChanged,
                                                     object: reachability)

              try reachability?.startNotifier()
          } catch let error {
              print("Unable to start Reachability! Error: \(error)")
          }
      } else {
          print("Unable to create Reachability!")
      }

      NotificationCenter.default.addObserver(self,
                                             selector: #selector(ReachabilityService.refreshReachability),
                                             name: UIApplication.willEnterForegroundNotification,
                                             object: nil)
  }

  deinit {
      NotificationCenter.default.removeObserver(self)
  }

  // MARK: Reachability changed

  @objc func refreshReachability() {
      if let reachability = self.reachability {
          NotificationCenter.default.post(name: Notification.Name.reachabilityChanged, object: reachability)
      }
  }

  @objc func reachabilityChanged(_ note: Notification) {
      guard let noteReachability = note.object as? Reachability, let reachability = self.reachability, reachability === noteReachability else {
          return
      }

      if reachability.connection != .none {
          //handle slow / fast mode here
          // TODO: - serviceCurrentRadioAccessTechnology for iOS 12  return always nil. To Investigate
          // Nothing found on Apple documentation, Apple Forum and stackoverflow
          if let currentRadioAccessTechnology = telephonyInfo.currentRadioAccessTechnology {
              switch currentRadioAccessTechnology {
              case CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyCDMA1x,
                   CTRadioAccessTechnologyGPRS:
                  //slow mode
                  changeOnlineMode(.onlineSlow)
              default:
                  //fast mode
                  changeOnlineMode(.online)
              }
          } else {
              changeOnlineMode(.online)
          }
      } else {
          changeOnlineMode(.offline)
      }
  }

  func changeOnlineMode(_ onlineMode: OnlineMode) {

      if let closure = changeOperatinModeClosure {
          closure!()
      }

      if onlineMode == .online || onlineMode == .onlineSlow {
          self.onlineMode = onlineMode
      } else {
          changeOperatinModeClosure = DispatchQueue.main.cancellableAsyncAfter(secondsDeadline: changeOperatingModeDelay) {
              self.onlineMode = onlineMode
          }
      }
  }

}
