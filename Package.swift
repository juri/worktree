// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let argParse = Target.Dependency.product(name: "ArgumentParser", package: "swift-argument-parser")

let package = Package(
    name: "Worktrees",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "worktree", targets: ["Worktrees"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "Worktrees",
            dependencies: [
                argParse,
            ]
        ),
        .testTarget(
            name: "WorktreesTests",
            dependencies: ["Worktrees"]),
    ]
)

