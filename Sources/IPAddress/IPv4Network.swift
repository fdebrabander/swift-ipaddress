/// Represent an IPv4 network address
struct IPv4Network: CustomStringConvertible {
    internal let ip: Int
    internal let prefix: Int

    /// Create a new IP network instance from a dot-decimal notation with prefix 'a.b.c.d/e'.
    init(string: String) throws {
        let address = try DotDecimalPrefixToInt(address: string)
        ip = address.ip
        prefix = address.prefix
    }
    
    init(network: Int, prefix: Int) {
        ip = network
        self.prefix = prefix
    }
    
    var description: String {
        return IntPrefixToDotDecimal(ip: ip, prefix: prefix)
    }
    
    /// The network mask as integer.
    ///
    /// For example when the prefix is /8 the integer value 0xFF000000 is returned.
    var mask: Int {
        PrefixToSubnetMask(prefix: prefix)
    }
    
    /// The network address as IPv4Address
    var networkAddress: IPv4Address {
        return IPv4Address(address: ip)
    }
    
    /// Broadcast address of the network
    var broadcastAddress: IPv4Address {
        return IPv4Address(address: ip & mask)
    }
    
    /// Determine if the IP address is part of this network
    func contains(ipaddress: IPv4Address) -> Bool {
        if (ipaddress.ip & mask) == ip {
            return true
        } else {
            return false
        }
    }

    /// Determine if some IP network is contained within this network
    func contains(network other: IPv4Network) -> Bool {
        if other.prefix < prefix {
            return false
        }

        if (other.ip & mask) == ip {
            return true
        } else {
            return false
        }
    }
}
