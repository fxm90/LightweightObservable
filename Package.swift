// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "LightweightObservable",
                      products: [
                          .library(name: "LightweightObservable",
                                   targets: ["LightweightObservable"]),
                      ],
                      targets: [
                          .target(name: "LightweightObservable",
                                  path: "LightweightObservable/"),
                          .testTarget(name: "LightweightObservableTests",
                                      dependencies: ["LightweightObservable"],
                                      path: "Example/Tests/"),
                      ])
