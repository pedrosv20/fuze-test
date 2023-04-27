// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "Networking", targets: ["Networking"]),
        .library(name: "CSTVMatchesServiceLive", targets: ["CSTVMatchesServiceLive"]),
        .library(name: "CSTVMatchesService", targets: ["CSTVMatchesService"]),
        .library(name: "MatchesListFeature", targets: ["MatchesListFeature"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", branch: "main"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", branch: "main")
    ],
    targets: [
        // CSGOMatchesService
        .cstvMatchesServiceLive,
        .cstvMatchesService,
        
        // Matches List
        .matchesListFeature,
        .matchesListFeatureTests,
        
        // Networking
        .networking,
    ]
)

fileprivate extension Target {
    static var cstvMatchesServiceLive = Target.target(
        name: "CSTVMatchesServiceLive",
        dependencies: [
            "CSTVMatchesService"
        ]
    )
    
    static var cstvMatchesService = Target.target(
        name: "CSTVMatchesService",
        dependencies: [
            "Networking",
            .product(name: "Dependencies", package: "swift-dependencies")
            
        ]
    )
}

fileprivate extension Target {
    static var matchesListFeature = Target.target(
        name: "MatchesListFeature",
        dependencies: [
            "CSTVMatchesService",
            .product(
                name: "ComposableArchitecture",
                package: "swift-composable-architecture"
            )
        ]
    )
    
    static var matchesListFeatureTests = Target.testTarget(
        name: "MatchesListFeatureTests",
        dependencies: ["MatchesListFeature"]
    )
}

fileprivate extension Target {
    static var networking = Target.target(
        name: "Networking",
        dependencies: []
    )
}
