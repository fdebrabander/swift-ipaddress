import XCTest
@testable import IPAddress

final class ReadmeTests: XCTestCase {
    func testExamples() throws {
        let ip1 = try IPv4Address(string: "192.168.0.1")
        let ip2 = try IPv4Address(string: "10.0.0.1")
        let network = try IPv4Network(string: "10.0.0.0/8")
        
        assert(ip1 != ip2, "should not match")
        
        assert(network.contains(ipaddress: ip2), "should contain ip")
    }
}
