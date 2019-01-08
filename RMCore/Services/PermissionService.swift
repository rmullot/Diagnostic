//
//  PermissionService.swift
//  RMCore
//
//  Created by Romain Mullot on 12/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

protocol PermissionServiceProtocol {
  static func askPermissionForCamera(completionHandler:@escaping (Bool) -> Void)
}

public final class PermissionService: PermissionServiceProtocol {

  // MARK: - Methods

  static public func askPermissionForCamera(completionHandler:@escaping (Bool) -> Void) {
    let cameraPermissionStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)

    switch cameraPermissionStatus {
    case .authorized:
        print("Already Authorized")
        completionHandler(true)
    case .denied:
        print("denied")
        AlertActionService.sharedInstance.showAlertWith(title: ConstantsCore.deniedAccessTitle, message: ConstantsCore.errorDeniedAccessCamera)
        completionHandler(false)
    case .restricted:
        print("restricted")
        completionHandler(true)
    default:
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in

            if granted {
                // User granted
                print("User granted")
                DispatchQueue.main.async {
                    completionHandler(true)
                }
            } else {
                // User Rejected
                print("User Rejected")
                AlertActionService.sharedInstance.showAlertWith(title: ConstantsCore.deniedAccessTitle, message: ConstantsCore.errorCameraCantBeUsedWithoutAccess)
                DispatchQueue.main.async {
                    completionHandler(false)
                }
            }
        })
    }
  }

  private init() {}
}
