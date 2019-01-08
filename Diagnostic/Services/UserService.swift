//
//  UserService.swift
//  Diagnostic
//
//  Created by Romain Mullot on 14/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation

protocol UserServiceProtocol {
    var currentUser: User { get set }
}

final class UserService: UserServiceProtocol {

  var currentUser: User = User()

  static let sharedInstance = UserService()

  // MARK: - Private Methods

  private init() {}
}
