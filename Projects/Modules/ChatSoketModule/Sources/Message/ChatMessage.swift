import Foundation

struct ChatMessage: Codable {
    var type: MessageType
    var content: String?
    var sender: String
    var roomId: String
}
