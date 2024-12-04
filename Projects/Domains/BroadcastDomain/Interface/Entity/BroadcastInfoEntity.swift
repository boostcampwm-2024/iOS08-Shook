public struct BroadcastInfoEntity {
    public let id: String
    public let title: String
    public let owner: String
    public let description: String

    public init(id: String, title: String, owner: String, description: String) {
        self.id = id
        self.title = title
        self.owner = owner
        self.description = description
    }
}
