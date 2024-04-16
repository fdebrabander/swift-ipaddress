enum IPAddressError : Error {
    case InvalidFormat(String)
    case ValueOutOfRange(String)
    case InvalidPrefix(String)
}
