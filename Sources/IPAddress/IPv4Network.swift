class IPv4Network: IPv4Address {
    internal var prefix: Int
    
    /// Create a new IP network instance from a dot-decimal notation with prefix 'a.b.c.d/e'.
    override init(string: String) throws {
        let chunks = string.split(separator: "/")
        guard chunks.count == 2 else {
            throw IPAddressError.InvalidFormat("does not conform to format a.b.c.d/e")
        }
        
        let byte = Int(chunks[1])
        guard let byte else {
            throw IPAddressError.InvalidFormat("network prefix not a valid number")
        }
        guard 0...32 ~= byte else {
            throw IPAddressError.ValueOutOfRange("network prefix must be in range [0, 32]")
        }
        prefix = byte
        
        try super.init(string: String(chunks[0]))
        
        guard ip & mask == ip else {
            throw IPAddressError.InvalidPrefix("host bits are not allowed to be set")
        }
    }
    
    init(network: Int, prefix: Int) {
        self.prefix = prefix
        super.init(address: network)
    }
    
    /// The network mask as integer.
    ///
    /// For example when the prefix is /8 the integer value 0xFF000000 is returned.
    var mask: Int {
        return 0xFFFFFFFF - (0xFFFFFFFF >> prefix)
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
