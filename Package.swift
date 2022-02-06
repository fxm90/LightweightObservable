// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "LightweightObservable",
                      products: [
                          // The external product of our package is an importable
                          // library that has the same name as the package itself.
                          .library(name: "LightweightObservable",
                                   targets: ["LightweightObservable"]),
                      ],
                      targets: [
                          .target(name: "LightweightObservable",
                                  path: "LightweightObservable/"),
                          .testTarget(name: "ExampleTests",
                                      dependencies: ["LightweightObservable"],
                                      path: "Example/ExampleTests/"),
                      ])
