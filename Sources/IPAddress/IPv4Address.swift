/// Represent an IPv4 address
public struct IPv4Address : CustomStringConvertible, Equatable {
    public let ip: Int

    /// Create a new IP address instance
    /// 
    /// - Parameter string: IPv4 address in dot-decimal notation `a.b.c.d`.
    public init(string: String) throws {
        ip = try DotDecimalToInt(ip: string)
    }
    
    public init(address: Int) {
        ip = address
    }
    
    /// Determine if the IP address is part of the loopback address range `127.0.0.0/8`
    public var isLoopback: Bool {
        return IPv4Network(network: 0x7F000000, prefix: 8).contains(ipaddress: self)
    }
    
    /// Determine if the IP address is part of any of the private network ranges, such as 10.0.0.0/8.
    public var isPrivate: Bool {
        return
            // 10.0.0.0/8
            IPv4Network(network: 0x0A000000, prefix: 8).contains(ipaddress: self) ||
            // 100.64.0.0/10
            IPv4Network(network: 0x64400000, prefix: 10).contains(ipaddress: self) ||
            // 172.16.0.0/12
            IPv4Network(network: 0xAC100000, prefix: 12).contains(ipaddress: self) ||
            // 192.0.0.0/24
            IPv4Network(network: 0xC0000000, prefix: 24).contains(ipaddress: self) ||
            // 192.168.0.0/16
            IPv4Network(network: 0xC0A80000, prefix: 16).contains(ipaddress: self) ||
            // 192.18.0.0/15
            IPv4Network(network: 0xC6120000, prefix: 15).contains(ipaddress: self)
    }
    
    public var description: String {
        IntToDotDecimal(ip: ip)
    }

    /// Create an IPv4Network for this IPv4Address
    /// 
    /// The created IPv4Network will have its host bits set to zero.
    /// 
    /// ```swift
    /// Create an IPv4Network for network 192.168.0.0/16
    /// let ip = try IPv4Address(string: "192.168.1.10")
    /// ip.network(withPrefix: 16)
    /// ```
    /// 
    /// - Parameter prefix: Routing prefix in the range 0...32.
    /// - Returns: IPv4Network based on this IP address and the given routing prefix.
    public func network(withPrefix prefix: Int) -> IPv4Network? {
        guard 0...32 ~= prefix else {
            return nil
        }
        let network = ip & PrefixToSubnetMask(prefix: prefix)
        return IPv4Network(network: network, prefix: prefix)
    }
}
