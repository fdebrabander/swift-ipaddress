/// Represent an IPv4 address
struct IPv4Address : CustomStringConvertible {
    internal var ip: Int

    /// Create a new IP address instance from dot-decimal notation 'a.b.c.d'.
    init(string: String) throws {
        ip = try DotDecimalToInt(ip: string)
    }
    
    internal init(address: Int) {
        ip = address
    }
    
    /// Determine if the IP address is part of the loopback address range 127.0.0.0/8
    var isLoopback: Bool {
        return IPv4Network(network: 0x7F000000, prefix: 8).contains(ipaddress: self)
    }
    
    /// Determine if the IP address is part of any of the private network ranges, such as 10.0.0.0/8.
    var isPrivate: Bool {
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
    
    var description: String {
        IntToDotDecimal(ip: ip)
    }
}
