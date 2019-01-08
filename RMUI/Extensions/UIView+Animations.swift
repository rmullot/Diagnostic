//
//  UIView+Animations.swift
//  RMUI
//
//  Created by Romain Mullot on 12/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation
import UIKit

public enum AnimationDuration: Double {
    case `default` = 0.25
}

extension UIView {

    /// Launch an animation of a flash camera
    public func flashAnimation() {
        let shutterView = UIView(frame: self.bounds)
        shutterView.backgroundColor = UIColor.white
        shutterView.alpha = 0.0
        DispatchQueue.main.async {
            self.addSubview(shutterView)
            UIView.animate(withDuration: TimeInterval(AnimationDuration.default.rawValue), animations: {
                shutterView.alpha = 1.0
            }, completion: { (_) in
                UIView.animate(withDuration: TimeInterval(AnimationDuration.default.rawValue), animations: {
                    shutterView.alpha = 0.0
                }, completion: { (_) in
                    shutterView.removeFromSuperview()
                })
            })
        }
    }

    /// Launch a 'fade in' animation of the current view
    /// - Parameters:
    ///     - duration: duration of the animation by default equal to AnimationDuration.default.rawValue
    public func fadeIn(_ duration: TimeInterval = AnimationDuration.default.rawValue) {
        fadeTo(1.0, duration: duration)
    }

    /// Launch a 'fade out' animation of the current view
    /// - Parameters:
    ///     - duration: duration of the animation by default equal to AnimationDuration.default.rawValue
    public func fadeOut(_ duration: TimeInterval = AnimationDuration.default.rawValue) {
        fadeTo(0.0, duration: duration)
    }

    /// Launch a 'fade' animation of the current view on the main thread in asynchrone mode
    /// - Parameters:
    ///     - alpha: new value of the alpha parameter of the current the view that we modify for the animation
    ///     - duration: duration of the animation
    private func fadeTo(_ alpha: CGFloat, duration: TimeInterval) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration) {
                self.alpha = alpha
            }
        }
    }

}
