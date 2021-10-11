// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EasyLayout",
    platforms: [ .iOS(.v12) ],
    products: [
        .library(
            name: "EasyLayout",
            targets: ["EasyLayout_ios"]),
    ],
    targets: [
        .target(
            name: "EasyLayout_ios",
            dependencies: [],
            path: "EasyLayout",
            exclude: ["EasyLayout.h", "Info.plist"]),
    ]
)
