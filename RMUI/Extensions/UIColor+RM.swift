//
//  UIColor+RM.swift
//  RMUI
//
//  Created by Romain Mullot on 09/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation
import UIKit

private enum Alpha: CGFloat {
    case available = 1
    case disable = 0.4
}

public extension UIColor {

    public static var bmEnableButtonColor: UIColor {
        return UIColor.black
    }

    public static var bmDisableButtonColor: UIColor {
        return UIColor.lightGray.withAlphaComponent(Alpha.disable.rawValue)
    }

    public static var activatedLampBackgroundColor: UIColor {
        return UIColor.white
    }

    public static var disactivatedLampBackgroundColor: UIColor {
        return UIColor.black
    }

    public static var activatedLampTitleColor: UIColor {
        return UIColor.blue
    }

    public static var disactivatedLampTitleColor: UIColor {
        return UIColor.white
    }

}
