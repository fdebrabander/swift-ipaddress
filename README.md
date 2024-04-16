# Swift IP address library
Library that contains types for IP addresses and networks.

```swift
import IPAddress

IPv4Network(string: "10.0.0.0/8").contains(ipaddress: IPv4Address(string: "10.1.0.1")
```

## Including this library
Update your `Package.swift` file to include these lines.

```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/fdebrabander/swift-ipaddress.git", from: "0.0.1"),
    ],
    targets: [
        .target(
            dependencies: ["IPAddress"]
        )
    ]
)
```
