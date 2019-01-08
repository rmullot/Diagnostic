//
//  UIDeviceOrientation+ImageOrientation.swift
//  RMCore
//
//  Created by Romain Mullot on 13/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation
import UIKit

extension UIDeviceOrientation {

  /// Variable permitting to obtain the orientation of the image base on UIDeviceOrientation
  /// - Note:
  /// The camera take a photo in landscape mode by default
  public var imageOrientation: UIImage.Orientation {
    switch self {
    case .portrait, .faceUp:                return .right
    case .portraitUpsideDown, .faceDown:    return .left
    case .landscapeLeft:                    return .up
    case .landscapeRight:                   return .down
    case .unknown:                          return .up
    }
  }
}
