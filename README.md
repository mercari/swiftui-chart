# SwiftUI Chart

This is a library to build charts in SwiftUI. This enables you to build charts with SwiftUI primitive `View` or `Shape` components, and simple declarative APIs.

## Motivation
There are many libraries to build charts in SwiftUI, but most of them are based on UIKit components. This library is based on SwiftUI primitive `View` or `Shape` components.

Also there is Apple's official library [Swift Charts](https://developer.apple.com/documentation/charts), but it is not open source and it builds charts with dedicated Result Builder ([`ChartContentBuilder`](https://developer.apple.com/documentation/charts/chartcontentbuilder)), so the knowledge of SwiftUI can't be used to build charts. In addition, it requires iOS 16+, so it can't be used for apps that support older iOS versions.

Chart SwiftUI is based on SwiftUI primitive `View` or `Shape` components, so you can build charts with SwiftUI knowledge. And it supports iOS 14+.

## Package Structure
This package contains 2 libraries.

- `ChartCore`
  - Core library to build charts.
  - Currently, it supports only `LineChart`.
    - We don't have a plan to support other charts that don't have a same coordinate system as `LineChart`.
- `LineChart`
  - Library to build line charts with `ChartCore`.

## Concept
We want to keep `ChartCore` as simple as possible. And `LineChart` only provides basic components to build line charts, these components are not necessarily to build line charts.

We want you to build your own various charts with `ChartCore` (and `LineChart`) by using SwiftUI `View` or `Shape` components.

This repository contains some examples under `Examples` directory. You can see how to build charts with `ChartCore` (and `LineChart`) by reading these examples. Almost all examples contain a custom chart that is not provided by `LineChart`.

## How to use
You can install `ChartCore` and `LineChart` with Swift Package Manager.

```swift
dependencies: [
    .package(url: "https://github.com/kouzoh/swiftui-chart.git", from: "0.1.0"),
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "LineChart", package: "SwiftUIChart"),
            // ChartCore is automatically imported if you import LineChart.
            .product(name: "ChartCore", package: "SwiftUIChart"),
        ]
    ),
]
```

Also you can see examples by opening `SwiftUIChart.xcworkspace` and running `Example` scheme.

## Committers
- [andooown](https://github.com/andooown)
- [daichiro](https://github.com/daichiro)

## Contribution

Please read the CLA carefully before submitting your contribution to Mercari. Under any circumstances, by submitting your contribution, you are deemed to accept and agree to be bound by the terms and conditions of the CLA.

https://www.mercari.com/cla/

## License

Copyright 2023 Mercari, Inc.

Licensed under the MIT License.

_Swift and SwiftUI are registered trademarks of Apple Inc._
