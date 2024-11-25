public struct ThumbnailResponseDTO: Decodable {
    let content: [ThumbnailResponse]
}

public struct ThumbnailResponse: Decodable {
    let name, url: String
}

extension ThumbnailResponse {
    public func toDomain() -> String {
        self.url
    }
}
