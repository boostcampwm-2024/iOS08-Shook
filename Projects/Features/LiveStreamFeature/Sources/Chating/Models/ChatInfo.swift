import Foundation

struct ChatInfo: Hashable {
    let id = UUID()
    let name: String
    let message: String
}
