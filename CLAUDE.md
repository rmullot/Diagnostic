# CLAUDE.md

This file provides guidance for working in the Diagnostic repository.

## Overview

Diagnostic is an iOS app (Xcode workspace `Diagnostic.xcworkspace`, project `Diagnostic.xcodeproj`) that guides a user through a small sequence of device self-checks — signing in, taking a test photo with the camera, running a timer — and then produces a report of the results. The app previously used CocoaPods; dependency management has since moved to Swift Package Manager, with two of the app's own modules (`RMCore`, `RMUI`) vendored in-repo as local Swift packages.

## Targets / modules

- **Diagnostic** — the app target. Contains `AppDelegate`/`SceneDelegate` (standard UIKit app + scene lifecycle, `SceneDelegate` forces `.light` interface style), `Constants.swift`, `UITestKey.swift` (accessibility identifiers used by UI tests), a `Resources/` group for localized strings, and a `Generated/` group holding SwiftGen-generated `Strings.swift`.
- **RMCore** (local SPM package, `RMCore/Package.swift`) — shared, UI-agnostic services and extensions: networking helpers (`NetworkActivityService`, `ReachabilityService` wrapping `Reachability.swift`, `MultiCastDelegate`, `MutexCounter`), `CameraService`, `PermissionService`, `AlertActionService`, `FormatterService`, and Foundation/UIKit extensions (`String+RM`, `UIImage+Base64`, `Date+DateFormatter`, `UIView+Constrainst`, etc.).
- **RMUI** (local SPM package, `RMUI/Package.swift`) — shared UI components (`RMButton`, `RMTextField` with its `.xib`) and UIKit extensions (`UIColor+RM`, `UIView+Animations`).
- **RMCoreTests / RMUITests / DiagnosticTests / DiagnosticUITests** — corresponding test targets.

## Remote SPM dependencies

Declared as `XCRemoteSwiftPackageReference` entries in `Diagnostic.xcodeproj/project.pbxproj` and linked as `packageProductDependencies` on the `Diagnostic` app target:
- `FTLinearActivityIndicator` (network activity indicator)
- `SwiftMessages` (in-app banners/toasts, used by `LocalhostServerService.displayNetworkStatus()`)
- `SwiftLint` (linked as a package reference; see `.swiftlint.yml`)
- `Reachability.swift` is pulled in transitively via `RMCore`'s own package dependencies.

## Architecture: MVVM

App code under `Diagnostic/MVVM/` is split into the classic three groups:
- `Models/` — plain data types, e.g. `Diagnostic.swift` (the diagnostic report payload, `Codable`), `User.swift`.
- `Views/` — `UIViewController` subclasses (`BaseViewController`, `SignInFormViewController`, `CameraDiagnosticViewController`, `ResultDiagnosticViewController`) plus their storyboards (`Main.storyboard`, `Launch Screen.storyboard`).
- `ViewModels/` — `BaseViewModel` plus one view model per screen (`SignInViewModel`, `CameraDiagnosticViewModel`, `ResultDiagnosticViewModel`), which the view controllers bind to.

## Services (singletons)

Business logic and cross-cutting concerns live in `Diagnostic/Services/` as classic Swift singletons (`static let sharedInstance`, `private init()`), each behind a small protocol for testability:
- `DiagnosticService` — holds the in-progress `Diagnostic` model, encodes it to JSON, and exposes mutators (`setPhotoPrint`, `setTimer`, `rebootDiagnostic`).
- `UserService` — holds the current signed-in `User`.
- `NavigationService` — looks up the key window's root `UINavigationController` via the connected `UIWindowScene` and pushes/pops the screens in sequence (sign-in → camera → result), guarding each transition on the currently visible view controller's type.
- `LocalhostServerService` — simulates sending the diagnostic report: it decodes the JSON, builds a human-readable feedback log, and fakes a network round trip with a `DispatchWorkItem` delayed via `DispatchQueue.main.asyncAfter` (no real network call is made). It also reacts to `ReachabilityService` connectivity changes (`ReachabilityServiceDelegate`) and surfaces network status via `SwiftMessages`.

## Other conventions

- Localized strings are managed with SwiftGen (`swiftgen.yml` at repo root) and generated into `Diagnostic/Generated/Strings.swift` (accessed via the generated `L10n` enum) as part of a build phase; do not hand-edit generated files.
- Linting is configured via `.swiftlint.yml` at the repo root.
- Supported languages: English (`en`, development region) and French (`fr`).
