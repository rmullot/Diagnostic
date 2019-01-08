//
//  FormatterService.swift
//  RMCore
//
//  Created by Romain Mullot on 13/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation

protocol FormatterServiceProtocol {
  func rebootCache()
  func formatterWith(format: String, timeZone: TimeZone, locale: Locale) -> DateFormatter
  func formatterWith(format: String, locale: String?) -> DateFormatter
  func formatterWith(format: String, locale: String?, timeZone: TimeZone) -> DateFormatter
  func parserDateFormatter() -> DateFormatter
  func bytesFormatter() -> ByteCountFormatter
}

public final class FormatterService: FormatterServiceProtocol {

  public static let sharedInstance = FormatterService()

  // MARK: Properties

  private var cachedFormatters = [String: Formatter]()
  private let bytesKey = "bytesFormatter"
  private let formatParser = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.000Z"
  private let parserKey = "parserDateFormatter"

  // MARK: Initialization

  private init() {
    NotificationCenter.default.addObserver(self, selector: #selector(FormatterService.rebootCache), name: NSLocale.currentLocaleDidChangeNotification, object: nil)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  // MARK: Cache

  @objc public func rebootCache() {
    cachedFormatters = cachedFormatters.filter { key, value in
        return !(value is DateFormatter && key != parserKey)
    }
    print(cachedFormatters)
  }

  // MARK: Getting formatters

  public func formatterWith(format: String, timeZone: TimeZone = TimeZone.autoupdatingCurrent, locale: Locale = Locale(identifier: "fr_FR")) -> DateFormatter {
      let key = "\(format.hashValue)\(timeZone.hashValue)\(locale.hashValue)"

      if let cachedDateFormatter = cachedFormatters[key] as? DateFormatter {
          return cachedDateFormatter
      } else {
          let newDateFormatter = DateFormatter()
          newDateFormatter.dateFormat = format
          newDateFormatter.timeZone = timeZone
          newDateFormatter.locale = locale
          cachedFormatters[key] = newDateFormatter
          return newDateFormatter
      }
  }

  public func formatterWith(format: String, locale: String?) -> DateFormatter {
    if let locale = locale {
        return self.formatterWith(format: format, timeZone: TimeZone.autoupdatingCurrent, locale: Locale(identifier: locale))
    } else {
        return self.formatterWith(format: format)
    }
  }

  public func formatterWith(format: String, locale: String?, timeZone: TimeZone) -> DateFormatter {
    if let locale = locale {
        return self.formatterWith(format: format, timeZone: TimeZone.autoupdatingCurrent, locale: Locale(identifier: locale))
    } else {
        return self.formatterWith(format: format, timeZone: timeZone)
    }
  }

  // Method permitting to have access directly to the formatter used for json parsing
  public func parserDateFormatter() -> DateFormatter {
    if let cachedDateFormatter = cachedFormatters[parserKey] as? DateFormatter {
        return cachedDateFormatter
    } else {
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.000Z"
        cachedFormatters[parserKey] = newDateFormatter

        return newDateFormatter
    }
  }

  public func bytesFormatter() -> ByteCountFormatter {
    if let formatter = cachedFormatters[bytesKey] as? ByteCountFormatter {
        return formatter
    } else {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB, .useKB, .useBytes]
        bcf.countStyle = .binary
        cachedFormatters[bytesKey] = bcf
        return bcf
    }
  }
}
