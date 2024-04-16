import XCTest
@testable import IPAddress

final class IPNetworkTests: XCTestCase {
    func testFromString() throws {
        let ip = try IPv4Network(string: "1.2.3.0/24")
        XCTAssertEqual(ip.ip, 0x01020300)
        XCTAssertEqual(ip.prefix, 24)
    }
    
    func testMask() throws {
        let slash8 = try IPv4Network(string: "1.0.0.0/8")
        let slash16 = try IPv4Network(string: "1.2.0.0/16")
        let slash24 = try IPv4Network(string: "1.2.3.0/24")

        XCTAssertEqual(slash8.mask, 0xFF000000)
        XCTAssertEqual(slash16.mask, 0xFFFF0000)
        XCTAssertEqual(slash24.mask, 0xFFFFFF00)
    }
    
    func testNetworkContainsNetwork() throws {
        try XCTAssertTrue(IPv4Network(string: "10.0.0.0/8").contains(network: IPv4Network(string: "10.1.0.0/16")))
        try XCTAssertFalse(IPv4Network(string: "10.0.0.0/8").contains(network: IPv4Network(string: "10.0.0.0/7")))
        try XCTAssertFalse(IPv4Network(string: "10.0.0.0/8").contains(network: IPv4Network(string: "9.255.0.0/16")))
    }
}
