public struct Channel: Hashable {
    let id: String
    let name: String
    var thumbnailImageURLString: String
    let owner: String
    let description: String

    public init(
        id: String,
        title: String,
        thumbnailImageURLString: String = "",
        owner: String = "",
        description: String = ""
    ) {
        self.id = id
        name = title
        self.thumbnailImageURLString = thumbnailImageURLString
        self.owner = owner
        self.description = description
    }
}
