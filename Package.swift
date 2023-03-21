// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "iFilemanager",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v14)
  ],
  products: [
    .library(
      name: "iFilemanager",
      targets: ["iFilemanager"])
  ],
  dependencies: [
    .package(url: "https://github.com/vapor/vapor.git", .exact("4.74.0")),
    .package(url: "https://github.com/vapor/leaf.git", .exact("4.2.4")),
    .package(url: "https://github.com/vapor/routing-kit.git", .exact("4.5.0")),
    .package(url: "https://github.com/weichsel/ZIPFoundation.git", .exact("0.9.16"))
  ],
  targets: [
    .target(
      name: "iFilemanager",
      dependencies: [
        .product(name: "Vapor", package: "vapor"),
        .product(name: "Leaf", package: "leaf"),
        .product(name: "ZIPFoundation", package: "ZIPFoundation")
      ],
      path: "Sources/swift",
      resources: [
        .copy("Resources/static"),
      ]),
    .testTarget(
      name: "iFilemanagerTests",
      dependencies: [
        "iFilemanager"
      ])
  ])
