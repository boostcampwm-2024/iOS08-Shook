public enum HTTPMethod: String, CustomStringConvertible {
    case get
    case head
    case post
    case put
    case delete
    case connect
    case options
    case trace
    case patch
    
    public var description: String { rawValue.uppercased() }
}
