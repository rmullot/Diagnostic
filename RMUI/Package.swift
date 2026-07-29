// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "RMUI",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "RMUI", targets: ["RMUI"]),
    ],
    targets: [
        .target(
            name: "RMUI",
            path: ".",
            exclude: ["Info.plist", "Package.swift"],
            resources: [
                .process("Components/RMTextField.xib"),
            ]
        ),
    ]
)
