// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// Bad Network
  internal static let badNetworkMessage = L10n.tr("Localizable", "badNetworkMessage")
  /// Simulator or unavailable camera.
  internal static let errorCameraUnavailable = L10n.tr("Localizable", "errorCameraUnavailable")
  /// Simulator or unavailable lamp.
  internal static let errorLampUnavailable = L10n.tr("Localizable", "errorLampUnavailable")
  /// Invalid email.
  internal static let errorMessageInvalidEmail = L10n.tr("Localizable", "errorMessageInvalidEmail")
  /// Invalid password.
  internal static let errorMessageInvalidPassword = L10n.tr("Localizable", "errorMessageInvalidPassword")
  /// Invalid sign.
  internal static let errorMessageInvalidSignInForm = L10n.tr("Localizable", "errorMessageInvalidSignInForm")
  /// Email field is a mandatory.
  internal static let errorMessageMandatoryEmail = L10n.tr("Localizable", "errorMessageMandatoryEmail")
  /// Password field is a mandatory.
  internal static let errorMessageMandatoryPassword = L10n.tr("Localizable", "errorMessageMandatoryPassword")
  /// Your password must have at least 8 characters.
  internal static let errorMessageTooShortPassword = L10n.tr("Localizable", "errorMessageTooShortPassword")
  /// Error
  internal static let errorTitle = L10n.tr("Localizable", "errorTitle")
  /// Unavailable or lost Network.
  internal static let errorUnavailableNetwork = L10n.tr("Localizable", "errorUnavailableNetwork")
  /// The photo is enough good?
  internal static let isThisPhotoIsGoodTitle = L10n.tr("Localizable", "isThisPhotoIsGoodTitle")
  /// \nDiagnostic prepared.\nSize %@. \nReady to be sent\n
  internal static func logDiagnosticReadyToSend(_ p1: String) -> String {
    return L10n.tr("Localizable", "logDiagnosticReadyToSend", p1)
  }
  /// photo not available. Device has failed the Photo Diagnostic
  internal static let logFailPhotoDiagnostic = L10n.tr("Localizable", "logFailPhotoDiagnostic")
  /// The server has received Photo diagnostic\n
  internal static let logReceivedPhotoDiagnostic = L10n.tr("Localizable", "logReceivedPhotoDiagnostic")
  /// photo size of %@ in PNG format.\n
  internal static func logSizePhoto(_ p1: String) -> String {
    return L10n.tr("Localizable", "logSizePhoto", p1)
  }
  /// The server has not received any diagnostics\n
  internal static let logUnavailableAllDiagnostics = L10n.tr("Localizable", "logUnavailableAllDiagnostics")
  /// The server has not received GPS Diagnostic\n
  internal static let logUnavailableGPSDiagnostic = L10n.tr("Localizable", "logUnavailableGPSDiagnostic")
  /// The server has not received Photo Diagnostic\n
  internal static let logUnavailablePhotoDiagnostic = L10n.tr("Localizable", "logUnavailablePhotoDiagnostic")
  /// The server has not received Touch Screen Diagnostic\n
  internal static let logUnavailableTouchScreenDiagnostic = L10n.tr("Localizable", "logUnavailableTouchScreenDiagnostic")
  /// Network available
  internal static let networkAvailableMessage = L10n.tr("Localizable", "networkAvailableMessage")
  /// No
  internal static let noTitle = L10n.tr("Localizable", "noTitle")
  /// OK
  internal static let okTitle = L10n.tr("Localizable", "okTitle")
  /// Yes
  internal static let yesTitle = L10n.tr("Localizable", "yesTitle")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
