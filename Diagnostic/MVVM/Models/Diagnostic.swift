//
//  Diagnostic.swift
//  Diagnostic
//
//  Created by Romain Mullot on 13/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation

struct PhotoDiagnostic: Codable {
    var photo: String?
}

struct GPSDiagnostic: Codable {
    var latitude: Float
    var longitude: Float
    var difference: Float
}

struct TouchScreenDiagnostic: Codable {
    var nbRows: Int
    var nbColumns: Int
    var nbCellslFilled: Int
}

struct Diagnostic: Codable {
    var photoTestData: PhotoDiagnostic?
    var gpsTestData: GPSDiagnostic?
    var touchScreenTestData: TouchScreenDiagnostic?
    var startTime: String = ""
    var endTime: String = ""
}
