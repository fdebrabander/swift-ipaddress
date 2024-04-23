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

## Quick guide
Create IPv4Address and IPv4Network objects

```swift
let ip1 = try IPv4Address(string: "192.168.0.1")
let ip2 = try IPv4Address(string: "10.0.0.1")
let network = try IPv4Network(string: "10.0.0.0/8")
```

Compare IP addresses

```swift
assert(ip1 != ip2, "should not match")
```

Determine if a network contains an IP address

```swift
assert(network.contains(ipaddress: ip2), "should contain ip")
```

Conversion between the different types

```swift
// Create an IPv4Network for network 192.168.0.0/16
let ip = try IPv4Address(string: "192.168.1.10")
ip.network(withPrefix: 16)
```

For the full documentation see the [Swift Package Index](https://swiftpackageindex.com/fdebrabander/swift-ipaddress/main/documentation/ipaddress).
