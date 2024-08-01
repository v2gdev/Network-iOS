// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "network-iOS",
  platforms: [.iOS(.v14), .macOS(.v12)],
  products: [
    .library(
      name: "network-iOS",
      targets: ["network-iOS"]),
  ],
  targets: [
    .target(
      name: "network-iOS"),
    .testTarget(
      name: "network-iOSTests",
      dependencies: ["network-iOS"]),
  ]
)
