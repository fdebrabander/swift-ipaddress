enum IPAddressError : Error {
    case InvalidFormat(String)
    case ValueOutOfRange(String)
    case InvalidPrefix(String)
}

/// Represent a IPv4 address
class IPv4Address : CustomStringConvertible {
    internal var ip: Int

    /// Create a new IP address instance from dot-decimal notation 'a.b.c.d'.
    init(string: String) throws {
        let chunks = string.split(separator: ".")
        guard chunks.count == 4 else {
            throw IPAddressError.InvalidFormat("does not conform to format a.b.c.d")
        }

        ip = 0
        var shift = 24
        for chunk in chunks {
            let byte_value = Int(chunk)
            if let byte_value {
                if !(0...255 ~= byte_value) {
                    throw IPAddressError.ValueOutOfRange("numbers of address must be in range [0, 255]")
                }
                
                ip += byte_value << shift
                shift -= 8
            } else {
                throw IPAddressError.InvalidFormat("invalid ip address format")
            }
        }
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
        return "\((ip >> 24) & 0xFF).\((ip >> 16) & 0xFF).\((ip >> 8) & 0xFF).\(ip & 0xFF)"
    }
}
