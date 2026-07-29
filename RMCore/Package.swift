// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "RMCore",
    defaultLocalization: "en",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "RMCore", targets: ["RMCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ashleymills/Reachability.swift.git", from: "5.1.0"),
    ],
    targets: [
        .target(
            name: "RMCore",
            dependencies: [
                .product(name: "Reachability", package: "Reachability.swift"),
            ],
            path: ".",
            exclude: ["Info.plist", "Package.swift"],
            resources: [
                .process("Resources/en.lproj"),
                .process("Resources/fr.lproj"),
            ]
        ),
    ]
)
