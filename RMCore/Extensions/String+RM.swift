//
//  String+RM.swift
//  RMCore
//
//  Created by Romain Mullot on 04/01/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import Foundation

extension String {

  /// Return a boolean checking if the string is not empty
  public var isNotEmpty: Bool {
    return !self.isEmpty
  }

  /// decode a base64 String into UIImage
  /// - Returns: A decoded image base on base64 enconding String or nil if the operation fails
  public func decodePhoto() -> UIImage? {
    guard self.isNotEmpty, let dataDecoded: Data = Data(base64Encoded: self, options: .ignoreUnknownCharacters), let decodedimage: UIImage = UIImage(data: dataDecoded) else { return nil }
    //      print(decodedimage)
    return decodedimage
  }

  // MARK: - Regex Methods

  /// Check if a string is an email
  public var isEmail: Bool {
    guard self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: " ", with: "").isNotEmpty else { return false }
    let regularExpression = "^([\\w-]+(?:\\.[\\w-]+)*)@((?:[\\w-]+\\.)*\\w[\\w-]{0,66})\\.([a-z]{2,6}(?:\\.[a-z]{2})?)$"
    return NSPredicate(format: "SELF MATCHES %@", regularExpression).evaluate(with: self)
  }

  /// Check if a string is a valid password
  /// - Note:
  /// For this project we have a fake test that's why we have 'Passw0rd' as a Regex
  public var isPasswordValid: Bool {
    guard self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: " ", with: "").isNotEmpty else { return false }
    let passwordValid = "Passw0rd"
    return self == passwordValid
  }
}
