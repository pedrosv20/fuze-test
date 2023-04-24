// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Networking",
            targets: ["Networking"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Networking
        .networking,
        .networkingTests,
        
        // Matches List
        .matchesList,
        .matchesListTests,
    ]
)

fileprivate extension Target {
    static var networking = Target.target(
        name: "Networking",
        dependencies: []
    )
    
    static var networkingTests = Target.testTarget(
        name: "NetworkingTests",
        dependencies: ["Networking"]
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
