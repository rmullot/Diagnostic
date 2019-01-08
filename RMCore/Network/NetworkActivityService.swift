//
//  NetworkActivityService.swift
//  RMCore
//
//  Created by Romain Mullot on 14/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation
import UIKit

// MARK: - NetworkActivityService Protocol

public protocol NetworkActivityServiceProtocol {
    var countRequest: MutexCounter { get set }
    func newRequestStarted() -> Int
    func requestFinished() -> Int
    func disableActivityIndicator()
}

// MARK: - NetworkActivityService

public final class NetworkActivityService: NetworkActivityServiceProtocol {

  public static let sharedInstance = NetworkActivityService()

  public var countRequest: MutexCounter = MutexCounter()

  private let maxActivityDuration: Double = 120 //in seconds

  private var disableActivityIndicatorClosure: DispatchQueue.CancellableClosure

  private init() {}

  @discardableResult
  public func newRequestStarted() -> Int {
      let count = countRequest.incrementAndGet()
      if !UIApplication.shared.isNetworkActivityIndicatorVisible {
          UIApplication.shared.isNetworkActivityIndicatorVisible = true
      }
      if let closure = disableActivityIndicatorClosure {
          closure()
      }

      disableActivityIndicatorClosure = DispatchQueue.main.cancellableAsyncAfter(secondsDeadline: maxActivityDuration) {
          self.disableActivityIndicator()
      }

      return count
  }

  @discardableResult
  public func requestFinished() -> Int {
      let count = countRequest.decrementAndGet()

      if count <= 0 {
          if let closure = disableActivityIndicatorClosure {
              closure()
          }
          countRequest.setValue(0)
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
      }
      return count
  }

  public func disableActivityIndicator() {
      if let closure = disableActivityIndicatorClosure {
          closure()
      }
      countRequest.setValue(0)
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

}
