//
//  DispatchQueue+Cancellable.swift
//  RMCore
//
//  Created by Romain Mullot on 14/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation

// Code permitting to simplify the posibility to cancel a task after some seconds if we need it.
extension DispatchQueue {
    typealias CancellableClosure = (() -> Void)?

    func asyncAfter(secondsDeadline: TimeInterval, qos: DispatchQoS = .default, flags: DispatchWorkItemFlags = [], execute work: @escaping @convention(block) () -> Swift.Void) {
        self.asyncAfter(deadline: DispatchTime.now() + secondsDeadline, qos: qos, flags: flags, execute: work)
    }

    func cancellableAsyncAfter(secondsDeadline: TimeInterval, execute work: @escaping @convention(block) () -> Swift.Void) -> CancellableClosure {
        var cancelled = false
        let cancelClosure: CancellableClosure = {
            cancelled = true
        }

        self.asyncAfter(secondsDeadline: secondsDeadline) {
            if !cancelled {
                work()
            }
        }

        return cancelClosure
    }
}
