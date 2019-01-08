//
//  MultiCastDelegate.swift
//  RMCore
//
//  Created by Romain Mullot on 14/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation

public final class MulticastDelegate <T> {

  private let lock: PThreadMutex = PThreadMutex()

  private let delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()

  fileprivate let addClosure: ((T) -> Void)?

  public init(addClosure: ((T) -> Void)? = nil) {
      self.addClosure = addClosure
  }

  public func add(_ delegate: T) {
      self.lock.sync {
          delegates.add(delegate as AnyObject)
          self.addClosure?(delegate)
      }
  }

  public func remove(_ delegate: T) {
      self.lock.sync {
          for oneDelegate in delegates.allObjects.reversed() where oneDelegate === delegate as AnyObject {
              delegates.remove(oneDelegate)
          }
      }
  }

  public func invoke(_ invocation: (T) -> Void) {
      self.lock.sync {
          for delegate in delegates.allObjects.reversed() {
              if let delegate = delegate as? T {
                  invocation(delegate)
              }
          }
      }
  }

}
