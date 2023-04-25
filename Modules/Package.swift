// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "Networking", targets: ["Networking"]),
        .library(name: "CSGOMatchesServiceLive", targets: ["CSGOMatchesServiceLive"]),
        .library(name: "CSGOMatchesService", targets: ["CSGOMatchesService"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", branch: "main")
    ],
    targets: [
        // CSGOMatchesService
        .csgoMatchesServiceLive,
        .csgoMatchesService,
        
        // Matches List
        .matchesList,
        .matchesListTests,
        
        // Networking
        .networking,
    ]
)

fileprivate extension Target {
    static var csgoMatchesServiceLive = Target.target(
        name: "CSGOMatchesServiceLive",
        dependencies: [
            "CSGOMatchesService",
            "Networking"
        ]
    )
    
    static var csgoMatchesService = Target.target(
        name: "CSGOMatchesService",
        dependencies: [
            "Networking"
//            .product(name: "Dependencies", package: "swift-composable-architecture"),
            
        ]
    )
}

fileprivate extension Target {
    static var matchesList = Target.target(
        name: "MatchesList",
        dependencies: []
    )
    
    static var matchesListTests = Target.testTarget(
        name: "MatchesListTests",
        dependencies: ["MatchesList"]
    )
}

fileprivate extension Target {
    static var networking = Target.target(
        name: "Networking",
        dependencies: []
    )
}
