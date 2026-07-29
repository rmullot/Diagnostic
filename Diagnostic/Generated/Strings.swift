// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Localizable.strings
  ///   
  /// 
  ///   Created by Romain Mullot on 15/01/2019.
  internal static let badNetworkMessage = L10n.tr("Localizable", "badNetworkMessage", fallback: "Bad Network")
  /// Simulator or unavailable camera.
  internal static let errorCameraUnavailable = L10n.tr("Localizable", "errorCameraUnavailable", fallback: "Simulator or unavailable camera.")
  /// Simulator or unavailable lamp.
  internal static let errorLampUnavailable = L10n.tr("Localizable", "errorLampUnavailable", fallback: "Simulator or unavailable lamp.")
  /// Invalid email.
  internal static let errorMessageInvalidEmail = L10n.tr("Localizable", "errorMessageInvalidEmail", fallback: "Invalid email.")
  /// Invalid password.
  internal static let errorMessageInvalidPassword = L10n.tr("Localizable", "errorMessageInvalidPassword", fallback: "Invalid password.")
  /// Invalid sign.
  internal static let errorMessageInvalidSignInForm = L10n.tr("Localizable", "errorMessageInvalidSignInForm", fallback: "Invalid sign.")
  /// Email field is a mandatory.
  internal static let errorMessageMandatoryEmail = L10n.tr("Localizable", "errorMessageMandatoryEmail", fallback: "Email field is a mandatory.")
  /// Password field is a mandatory.
  internal static let errorMessageMandatoryPassword = L10n.tr("Localizable", "errorMessageMandatoryPassword", fallback: "Password field is a mandatory.")
  /// Your password must have at least 8 characters.
  internal static let errorMessageTooShortPassword = L10n.tr("Localizable", "errorMessageTooShortPassword", fallback: "Your password must have at least 8 characters.")
  /// Error
  internal static let errorTitle = L10n.tr("Localizable", "errorTitle", fallback: "Error")
  /// Unavailable or lost Network.
  internal static let errorUnavailableNetwork = L10n.tr("Localizable", "errorUnavailableNetwork", fallback: "Unavailable or lost Network.")
  /// The photo is enough good?
  internal static let isThisPhotoIsGoodTitle = L10n.tr("Localizable", "isThisPhotoIsGoodTitle", fallback: "The photo is enough good?")
  /// 
  /// Diagnostic prepared.
  /// Size %@. 
  /// Ready to be sent
  /// 
  internal static func logDiagnosticReadyToSend(_ p1: Any) -> String {
    return L10n.tr("Localizable", "logDiagnosticReadyToSend", String(describing: p1), fallback: "\nDiagnostic prepared.\nSize %@. \nReady to be sent\n")
  }
  /// photo not available. Device has failed the Photo Diagnostic
  internal static let logFailPhotoDiagnostic = L10n.tr("Localizable", "logFailPhotoDiagnostic", fallback: "photo not available. Device has failed the Photo Diagnostic")
  /// The server has received Photo diagnostic
  /// 
  internal static let logReceivedPhotoDiagnostic = L10n.tr("Localizable", "logReceivedPhotoDiagnostic", fallback: "The server has received Photo diagnostic\n")
  /// photo size of %@ in PNG format.
  /// 
  internal static func logSizePhoto(_ p1: Any) -> String {
    return L10n.tr("Localizable", "logSizePhoto", String(describing: p1), fallback: "photo size of %@ in PNG format.\n")
  }
  /// The server has not received any diagnostics
  /// 
  internal static let logUnavailableAllDiagnostics = L10n.tr("Localizable", "logUnavailableAllDiagnostics", fallback: "The server has not received any diagnostics\n")
  /// The server has not received GPS Diagnostic
  /// 
  internal static let logUnavailableGPSDiagnostic = L10n.tr("Localizable", "logUnavailableGPSDiagnostic", fallback: "The server has not received GPS Diagnostic\n")
  /// The server has not received Photo Diagnostic
  /// 
  internal static let logUnavailablePhotoDiagnostic = L10n.tr("Localizable", "logUnavailablePhotoDiagnostic", fallback: "The server has not received Photo Diagnostic\n")
  /// The server has not received Touch Screen Diagnostic
  /// 
  internal static let logUnavailableTouchScreenDiagnostic = L10n.tr("Localizable", "logUnavailableTouchScreenDiagnostic", fallback: "The server has not received Touch Screen Diagnostic\n")
  /// Network available
  internal static let networkAvailableMessage = L10n.tr("Localizable", "networkAvailableMessage", fallback: "Network available")
  /// No
  internal static let noTitle = L10n.tr("Localizable", "noTitle", fallback: "No")
  /// OK
  internal static let okTitle = L10n.tr("Localizable", "okTitle", fallback: "OK")
  /// Yes
  internal static let yesTitle = L10n.tr("Localizable", "yesTitle", fallback: "Yes")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
