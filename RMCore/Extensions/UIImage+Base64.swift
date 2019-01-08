//
//  UIImage+Base64.swift
//  RMCore
//
//  Created by Romain Mullot on 13/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    /// encode a photo in base64
    /// - Note:
    ///  the Data respect just the PNG Format
    /// - Returns: an encoding base64 String base on the image in question
    public func encodePhotoBase64() -> String {
        guard let imageData: Data = self.pngData() else {
            return ""
        }
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        //      print(strBase64)
        return strBase64
    }
}
