//
//  ConstantsCore.swift
//  RMCore
//
//  Created by Romain Mullot on 15/01/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import Foundation

// MARK: - Strings

internal enum ConstantsCore {

  internal static let deniedAccessTitle = ConstantsCore.tr("Localizable", "deniedAccessTitle")
  /// No
  internal static let errorCameraCantBeUsedWithoutAccess = ConstantsCore.tr("Localizable", "errorCameraCantBeUsedWithoutAccess")
  /// OK
  internal static let okTitle = ConstantsCore.tr("Localizable", "okTitle")
  /// Yes
  internal static let errorDeniedAccessCamera = ConstantsCore.tr("Localizable", "errorDeniedAccessCamera")
}

// MARK: - Implementation Details

extension ConstantsCore {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
