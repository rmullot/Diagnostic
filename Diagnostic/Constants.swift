//
//  Constants.swift
//  Diagnostic
//
//  Created by Romain Mullot on 10/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation

class Constants {

  // MARK: - Durations

  static let defaultAnimationDuration = 0.25

  static let flashAnimationKey = "flashAnimationKey"

  // MARK: - Text

  static let badNetworkMessage = "Réseau de mauvaise qualité"

  static let errorTitle = "Erreur"

  static let isThisPhotoIsGoodTitle = "La photo est-elle bien?"

  static let networkAvailableMessage = "Réseau disponible"

  static let noTitle = "Non"

  static let okTitle = "OK"

  static let yesTitle = "Oui"

  // MARK: - Queue

  static let cameraNameQueue = "cameraOutput"

  // MARK: - Error Text

  static let errorCameraUnavailable = "Simulateur ou camera indisponible."

  static let errorLampUnavailable = "Simulateur ou lampe indisponible."

  static let errorMessageInvalidEmail = "Votre adresse email est erronée."

  static let errorMessageInvalidPassword = "Votre mot de passe est erroné."

  static let errorMessageInvalidSignInForm = "Combinaison invalide."

  static let errorMessageMandatoryEmail = "Le champ adresse email est obligatoire."

  static let errorMessageMandatoryPassword = "Le champ mot de passe est obligatoire."

  static let errorMessageTooShortPassword = "Votre mot de passe doit être d'au moins 8 charactères."

  static let errorUnavailableNetwork = "Réseau indisponible ou perdu."

  // MARK: - Diagnostic logs

  static let logDiagnosticReadyToSend = "\nDiagnostic preparé.\nTaille %@. \nPrêt à être envoyé\n"

  static let logReceivedPhotoDiagnostic = "Le serveur a reçu un diagnostic Photo\n"

  static let logSizePhoto = "photo d'une taille de %@ au format PNG.\n"

  static let logFailPhotoDiagnostic = "photo indisponible. Appareil ayant échoué au diagnostic Photo"

  static let logUnavailablePhotoDiagnostic = "Le serveur n'a pas reçu de Diagnostic Photo\n"

  static let logUnavailableGPSDiagnostic = "Le serveur n'a pas reçu de Diagnostic GPS\n"

  static let logUnavailableTouchScreenDiagnostic = "Le serveur n'a pas reçu de Diagnostic Touch Screen\n"

  static let logUnavailableAllDiagnostics = "Le serveur a reçu aucun diagnostics\n"

  private init() {}
}
