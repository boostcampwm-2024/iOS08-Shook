import UIKit

public struct ChannelEntity {
    public let id: String
    public let name: String
    public let image: UIImage?
    
    public init(id: String, name: String, image: UIImage? = nil) {
        self.id = id
        self.name = name
        self.image = image
    }
}
