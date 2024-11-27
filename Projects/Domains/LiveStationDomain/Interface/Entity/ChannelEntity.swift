import UIKit

public struct ChannelEntity {
    public let id: String
    public let name: String
    public var imageURLString: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
        self.imageURLString = ""
    }
}
