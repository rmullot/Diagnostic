//
//  UIView+Constrainst.swift
//  RMCore
//
//  Created by Romain Mullot on 13/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation

extension UIView {

  /// Add a subview to the current view wich match perfectly the size of this one
  public func addSubViewWithAutoresizingConstrainst(view: UIView) {
    guard view.superview == nil else { return }
    commonConfiguration(view)
  }

  /// Add a subview to the current view wich match perfectly the size of this one in using a xib file
  public func instantiate(from nibName: String) {
    let bundle = Bundle(for: type(of: self))
    guard let view = UINib(nibName: nibName, bundle: bundle).instantiate(withOwner: self, options: nil).first as? UIView else { return }
    commonConfiguration(view)
  }

  private func commonConfiguration(_ view: UIView) {
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.frame = bounds
    view.layer.masksToBounds = true
    view.translatesAutoresizingMaskIntoConstraints = true
    addSubview(view)
  }
}
