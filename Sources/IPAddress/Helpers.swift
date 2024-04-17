/// Convert a routing prefix to a subnet mask.
///
/// For example when the prefix is /8 the integer value 0xFF000000 is returned.
func PrefixToSubnetMask(prefix: Int) -> Int {
    return 0xFFFFFFFF - (0xFFFFFFFF >> prefix)
}

/// Convert an integer representing an IPv4 address to a dot-decimal string.
func IntToDotDecimal(ip: Int) -> String {
    return "\((ip >> 24) & 0xFF).\((ip >> 16) & 0xFF).\((ip >> 8) & 0xFF).\(ip & 0xFF)"
}

/// Convert integers representing an IPv4 address and prefix length to a dot-decimal string.
///
/// - Parameters:
///   - ip: IP address as an integer value
///   - prefix: Routing prefix of the IP address
func IntPrefixToDotDecimal(ip: Int, prefix: Int) -> String {
    return IntToDotDecimal(ip: ip) + "/\(prefix)"
}

/// Convert IPv4 address in dot-decimal notation to an integer.
func DotDecimalToInt(ip string: String) throws -> Int {
    let chunks = string.split(separator: ".")
    guard chunks.count == 4 else {
        throw IPAddressError.InvalidFormat("does not conform to format a.b.c.d")
    }
    
    var ip = 0
    var shift = 24
    for chunk in chunks {
        if let byte_value = Int(chunk) {
            if !(0...255 ~= byte_value) {
                throw IPAddressError.ValueOutOfRange("numbers of address must be in range [0, 255]")
            }
            
            ip += byte_value << shift
            shift -= 8
        } else {
            throw IPAddressError.InvalidFormat("invalid ip address format")
        }
    }
    return ip
}

/// Convert IPv4 address with prefix in dot-decimal notation to integers
///
/// - Parameters:
///   - address: IPv4 address with routing prefix in format 'a.b.c.d/e'
///
/// - Returns: Tuple with the IPv4 address and the routing prefix as integers.
func DotDecimalPrefixToInt(address: String) throws -> (ip: Int, prefix: Int) {
    let chunks = address.split(separator: "/")
    guard chunks.count == 2 else {
        throw IPAddressError.InvalidFormat("does not conform to format a.b.c.d/e")
    }
    
    let prefix = Int(chunks[1])
    guard let prefix else {
        throw IPAddressError.InvalidFormat("network prefix not a valid number")
    }
    guard 0...32 ~= prefix else {
        throw IPAddressError.ValueOutOfRange("network prefix must be in range [0, 32]")
    }
    
    let ip = try DotDecimalToInt(ip: String(chunks[0]))
    
    guard ip & PrefixToSubnetMask(prefix: prefix) == ip else {
        throw IPAddressError.InvalidPrefix("host bits are not allowed to be set")
    }
    
    return (ip, prefix)
}
