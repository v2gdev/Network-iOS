// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Network-iOS",
  platforms: [.iOS(.v14), .macOS(.v12)],
  products: [
    .library(
      name: "Network-iOS",
      targets: ["Network-iOS"]),
  ],
  targets: [
    .target(
      name: "Network-iOS"),
    .testTarget(
      name: "Network-iOSTests",
      dependencies: ["Network-iOS"]),
  ]
)
