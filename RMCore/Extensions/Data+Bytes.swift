//
//  Data+Bytes.swift
//  RMCore
//
//  Created by Romain Mullot on 14/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation

extension Data {

  /// Return the size in bytes of the current data  in String format
  /// - Returns: A formatted string corresonding at bytesFormatter configuration
  public func toBytesString() -> String {
    return FormatterService.sharedInstance.bytesFormatter().string(fromByteCount: Int64(self.count))
  }
}
