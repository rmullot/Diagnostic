//
//  DiagnosticService.swift
//  Diagnostic
//
//  Created by Romain Mullot on 13/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation

protocol DiagnosticServiceProtocol {
    func getDiagnosticJSON(completionHandler:@escaping (Data) -> Void)
    func setPhotoPrint(photoBase64: String)
    func setTimer(_ date: Date, isLaunched: Bool)
    func rebootDiagnostic()
}

final class DiagnosticService: DiagnosticServiceProtocol {

    static let sharedInstance = DiagnosticService()

    // MARK: Properties

    private var currentDiagnostic = Diagnostic()

    // MARK: - Methods

    func getDiagnosticJSON(completionHandler: @escaping (Data) -> Void) {

      DispatchQueue.global(qos: .background).async {
          var log = Data()
          do {
              log = try JSONEncoder().encode(self.currentDiagnostic)
          } catch EncodingError.invalidValue(let key, let context) {
              print("Key '\(key)' not found:", context.debugDescription)
              print("codingPath:", context.codingPath)
          } catch {
              print("error: ", error)
          }
          DispatchQueue.main.async {
              completionHandler(log)
          }
      }
    }

    func setPhotoPrint(photoBase64: String) {
      if currentDiagnostic.photoTestData == nil {
          currentDiagnostic.photoTestData = PhotoDiagnostic()
      }
      currentDiagnostic.photoTestData!.photo = photoBase64
    }

    func setTimer(_ date: Date, isLaunched: Bool) {
      if isLaunched {
          currentDiagnostic.startTime = date.toParsedString()
      } else {
          currentDiagnostic.endTime = date.toParsedString()
      }
    }

    func rebootDiagnostic() {
      currentDiagnostic = Diagnostic()
    }
    // MARK: - Private Methods

    private init() {}
}
