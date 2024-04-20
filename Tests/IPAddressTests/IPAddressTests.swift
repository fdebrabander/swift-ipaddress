import XCTest
@testable import IPAddress

final class IPAddressTests: XCTestCase {
    func testFromString() throws {
        let ip = try IPv4Address(string: "1.2.3.4")
        XCTAssertEqual(ip.ip, 0x01020304)
    }
    
    func testToString() throws {
        let ip = try IPv4Address(string: "1.2.3.4")
        XCTAssertEqual("1.2.3.4", String(describing: ip))
    }
    
    func testInvalidStringFormat() throws {
        XCTAssertThrowsError(try IPv4Address(string:""))
        XCTAssertThrowsError(try IPv4Address(string:"1.2.3."))
        XCTAssertThrowsError(try IPv4Address(string:"1.2.3.x"))
        XCTAssertThrowsError(try IPv4Address(string:"1.2.3.256")) {error in
            XCTAssert(error is IPAddressError)
        }
    }
    
    func testIsLoopback() throws {
        try XCTAssertFalse(IPv4Address(string: "126.255.255.255").isLoopback)
        try XCTAssertTrue(IPv4Address(string: "127.0.0.1").isLoopback)
        try XCTAssertFalse(IPv4Address(string: "128.0.0.0").isLoopback)
    }
    
    func testPrivateRanges() throws {
        try XCTAssertFalse(IPv4Address(string: "9.255.255.255").isPrivate)
        try XCTAssertTrue(IPv4Address(string: "10.0.0.1").isPrivate)
        try XCTAssertFalse(IPv4Address(string: "11.0.0.0").isPrivate)
        
        try XCTAssertFalse(IPv4Address(string: "100.63.255.255").isPrivate)
        try XCTAssertTrue(IPv4Address(string: "100.64.0.1").isPrivate)
        try XCTAssertFalse(IPv4Address(string: "100.128.0.0").isPrivate)

        try XCTAssertFalse(IPv4Address(string: "172.15.255.255").isPrivate)
        try XCTAssertTrue(IPv4Address(string: "172.16.0.1").isPrivate)
        try XCTAssertFalse(IPv4Address(string: "172.32.0.0").isPrivate)

        try XCTAssertFalse(IPv4Address(string: "191.255.255.255").isPrivate)
        try XCTAssertTrue(IPv4Address(string: "192.0.0.1").isPrivate)
        try XCTAssertFalse(IPv4Address(string: "191.0.1.0").isPrivate)

        try XCTAssertFalse(IPv4Address(string: "192.167.255.255").isPrivate)
        try XCTAssertTrue(IPv4Address(string: "192.168.0.1").isPrivate)
        try XCTAssertFalse(IPv4Address(string: "192.169.0.0").isPrivate)

        try XCTAssertFalse(IPv4Address(string: "198.17.255.255").isPrivate)
        try XCTAssertTrue(IPv4Address(string: "198.18.0.1").isPrivate)
        try XCTAssertFalse(IPv4Address(string: "198.20.0.0").isPrivate)
    }
    
    func testEquatable() throws {
        XCTAssertTrue(try IPv4Address(string: "192.168.0.1") == IPv4Address(string: "192.168.0.1"))
        XCTAssertFalse(try IPv4Address(string: "192.168.0.1") == IPv4Address(string: "192.168.0.0"))
        XCTAssertFalse(try IPv4Address(string: "192.168.0.1") == IPv4Address(string: "192.168.0.2"))

        XCTAssertFalse(try IPv4Address(string: "192.168.0.1") != IPv4Address(string: "192.168.0.1"))
        XCTAssertTrue(try IPv4Address(string: "192.168.0.1") != IPv4Address(string: "192.168.0.0"))
    }

    func ipToNetwork() throws {
        let ip = try IPv4Address(string: "192.168.1.10")
        let network = ip.network(withPrefix: 16)
        XCTAssertEqual(try IPv4Network(string: "192.168.0.0/16"), network!)
    }
}
