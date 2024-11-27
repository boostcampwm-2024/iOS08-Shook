import Foundation

struct ChatInfo: Hashable {
    let id = UUID()
    let owner: ChatOwner
    let message: String
}

enum ChatOwner: Hashable {
    case user(name: String)
    case system
    
    var name: String {
        switch self {
        case let .user(name): return name
        case .system: return "System"
        }
    }
}
