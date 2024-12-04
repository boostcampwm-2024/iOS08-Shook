// MARK: - ThumbnailResponseDTO

public struct ThumbnailResponseDTO: Decodable {
    let content: [ThumbnailResponse]
}

// MARK: - ThumbnailResponse

public struct ThumbnailResponse: Decodable {
    let name, url: String
}

public extension ThumbnailResponse {
    func toDomain() -> String {
        url
    }
}
