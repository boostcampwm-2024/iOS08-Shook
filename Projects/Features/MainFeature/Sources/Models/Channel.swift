import UIKit

public struct Channel: Hashable {
    let id: String
    let name: String
    var thumbnailImageURLString: String
    var thumbnailImage: UIImage?
    let owner: String
    let description: String

    public init(
        id: String,
        title: String,
        thumbnailImageURLString: String = "",
        thumbnailImage: UIImage? = nil,
        owner: String = "",
        description: String = ""
    ) {
        self.id = id
        self.name = title
        self.thumbnailImageURLString = thumbnailImageURLString
        self.thumbnailImage = thumbnailImage
        self.owner = owner
        self.description = description
    }
}
