/// Represent an IPv4 network address
public struct IPv4Network: CustomStringConvertible, Equatable {
    public let ip: Int
    public let prefix: Int

    /// Create a new IPv4Network instance
    /// 
    /// - Parameter string: Network adreess in dot-decimal notation `a.b.c.d/e`.
    public init(string: String) throws {
        let address = try DotDecimalPrefixToInt(address: string)
        ip = address.ip
        prefix = address.prefix
    }
    
    /// Create a new IPv4Network instance.
    /// 
    /// - Parameters:
    ///   - network: Network address as a 32-bit integer value.
    ///   - prefix: Routing prefix in the range 0...32.
    public init(network: Int, prefix: Int) {
        ip = network
        self.prefix = prefix
    }
    
    public var description: String {
        return IntPrefixToDotDecimal(ip: ip, prefix: prefix)
    }
    
    /// The network mask as integer.
    ///
    /// For example when the prefix is /8 the integer value 0xFF000000 is returned.
    public var mask: Int {
        PrefixToSubnetMask(prefix: prefix)
    }
    
    /// The network address as an IPv4Address
    public var networkAddress: IPv4Address {
        return IPv4Address(address: ip)
    }
    
    /// Broadcast address of the network
    public var broadcastAddress: IPv4Address {
        return IPv4Address(address: ip & mask)
    }
    
    /// Determine if the IP address is part of this network
    public func contains(ipaddress: IPv4Address) -> Bool {
        if (ipaddress.ip & mask) == ip {
            return true
        } else {
            return false
        }
    }

    /// Determine if some IP network is contained within this network
    public func contains(network other: IPv4Network) -> Bool {
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
