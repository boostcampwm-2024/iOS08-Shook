import Foundation

public struct ChatMessage: Codable {
    public let type: MessageType
    public let content: String?
    public let sender: String
    public let roomId: String
    
    public init(type: MessageType, content: String?, sender: String, roomId: String) {
        self.type = type
        self.content = content
        self.sender = sender
        self.roomId = roomId
    }
}
