//
//  BaseViewModel.swift
//  Diagnostic
//
//  Created by Romain Mullot on 09/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation

typealias PropertyChangedClosure = (_ name: String) -> Void

protocol BaseViewModelProtocol {
    func validate()
    var propertyChanged: PropertyChangedClosure? {get set}
}

class BaseViewModel: BaseViewModelProtocol {

    required init() {
    }

    // MARK: - Public Properties

    enum PropertyNames: String {
      case errorMessage
      case isValid
    }

    var isValid: Bool {
      return false
    }
    var propertyChanged: PropertyChangedClosure?

    var errorMessage: String = "" {
      didSet {
          propertyChanged?(PropertyNames.errorMessage.rawValue)
      }
    }

    func validate() {
      if isValid { propertyChanged?(PropertyNames.isValid.rawValue) }
    }
}
