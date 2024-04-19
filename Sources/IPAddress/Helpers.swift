/// Convert a routing prefix to a subnet mask.
///
/// For example when the prefix is /8 the integer value 0xFF000000 is returned.
/// 
/// - Parameter prefix: Routing prefix in the range 0...32.
/// - Returns: Subnet mask as a 32-bit integer value.
public func PrefixToSubnetMask(prefix: Int) -> Int {
    precondition(0...32 ~= prefix)
    return 0xFFFFFFFF - (0xFFFFFFFF >> prefix)
}

/// Convert an integer representing an IPv4 address to a dot-decimal string.
/// 
/// - Parameter ip: IPv4 address as a 32-bit integer value.
/// - Returns: Dot-decimal string representation of the IPv4 address.
public func IntToDotDecimal(ip: Int) -> String {
    precondition(ip >= 0 && ip <= UInt32.max)
    return "\((ip >> 24) & 0xFF).\((ip >> 16) & 0xFF).\((ip >> 8) & 0xFF).\(ip & 0xFF)"
}

/// Convert integers representing an IPv4 address and prefix length to a dot-decimal string.
///
/// This will return the string "10.0.0.0/8".
/// ```swift
/// IntPrefixToDotDecimal(ip: 167772160, prefix: 8)
/// ```
/// 
/// - Parameters:
///   - ip: IP address as an 32-bit integer value
/// - Parameter prefix: Routing prefix in the range 0...32.
/// - Returns: String representation of the IPv4 address.
public func IntPrefixToDotDecimal(ip: Int, prefix: Int) -> String {
    precondition(0...32 ~= prefix)
    return IntToDotDecimal(ip: ip) + "/\(prefix)"
}

/// Convert an IPv4 address in dot-decimal notation to an integer.
///
/// Convert a string to integer with:
/// ```swift
/// let ip = DotDecimalToInt(ip: "10.0.0.1")
/// ```
/// 
/// - Parameters:
///   - address: IPv4 address in format `a.b.c.d`.
///
/// - Returns: IPv4 address as integer.
public func DotDecimalToInt(ip string: String) throws -> Int {
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

/// Convert an IPv4 address with prefix in dot-decimal notation to integers
///
/// Convert a string to integers with:
/// ```swift
/// let (ip, prefix) = DotDecimalPrefixToInt(address: "10.0.0.0/8")
/// ```
/// 
/// The hosts bits of the IP address are not allowed to be set.
/// 
/// - Parameters:
///   - address: IPv4 address with routing prefix in format `a.b.c.d/e`.
///
/// - Returns: Tuple with the IPv4 address and the routing prefix as integers.
public func DotDecimalPrefixToInt(address: String) throws -> (ip: Int, prefix: Int) {
    let chunks = address.split(separator: "/")
    guard chunks.count == 2 else {
        throw IPAddressError.InvalidFormat("does not conform to format a.b.c.d/e")
    }
    
    guard let prefix = Int(chunks[1]) else {
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
