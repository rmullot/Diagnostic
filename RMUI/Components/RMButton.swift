//
//  RMButton.swift
//  RMUI
//
//  Created by Romain Mullot on 12/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import UIKit

public class RMButton: UIButton {

    override public var isEnabled: Bool {
        didSet {
            self.backgroundColor  = isEnabled ? UIColor.bmEnableButtonColor : UIColor.bmDisableButtonColor
        }
    }

}
