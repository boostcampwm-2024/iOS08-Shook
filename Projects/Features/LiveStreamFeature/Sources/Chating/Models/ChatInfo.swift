import Foundation

// MARK: - ChatInfo

struct ChatInfo: Hashable {
    let id = UUID()
    let owner: ChatOwner
    let message: String
}

// MARK: - ChatOwner

enum ChatOwner: Hashable {
    case user(name: String)
    case system

    var name: String {
        switch self {
        case let .user(name): name
        case .system: "System"
        }
    }
}
