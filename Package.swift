// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "iFilemanager",
  platforms: [
    .iOS(.v14)
  ],
  products: [
    .library(
      name: "iFilemanager",
      targets: ["iFilemanager"])
  ],
  dependencies: [
    .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
    .package(url: "https://github.com/vapor/leaf.git", from: "4.2.4"),
    .package(url: "https://github.com/weichsel/ZIPFoundation.git", from: "0.9.16"),
  ],
  targets: [
    .target(
      name: "iFilemanager",
      dependencies: [
        .product(name: "Vapor", package: "vapor"),
        .product(name: "Leaf", package: "leaf"),
        .product(name: "ZIPFoundation", package: "ZIPFoundation"),
      ],
      resources: [
        .copy("Resources/css"),
        .copy("Resources/fonts"),
        .copy("Resources/img"),
        .copy("Resources/js"),
        .copy("Resources/index.leaf"),
      ]),
    .testTarget(
      name: "iFilemanagerTests",
      dependencies: [
        "iFilemanager"
      ]),
  ])
