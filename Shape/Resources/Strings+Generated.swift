// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Breeds
  internal static let breeds = L10n.tr("Strings", "breeds")
  /// Cancel
  internal static let dismissAlertWindow = L10n.tr("Strings", "dismiss_alert_window")
  /// Done
  internal static let done = L10n.tr("Strings", "done")
  /// Can't load the information, try again
  internal static let errorNetworkResponse = L10n.tr("Strings", "error_network_response")
  /// Favorites
  internal static let favorites = L10n.tr("Strings", "favorites")
  /// Filter
  internal static let filter = L10n.tr("Strings", "Filter")
  /// Reload
  internal static let tryReloadData = L10n.tr("Strings", "try_reload_data")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
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
