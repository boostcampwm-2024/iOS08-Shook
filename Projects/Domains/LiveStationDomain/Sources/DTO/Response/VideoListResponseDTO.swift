import LiveStationDomainInterface

// MARK: - VideoListResponseDTO

public struct VideoListResponseDTO: Decodable {
    let content: [VideoResponse]
}

// MARK: - VideoResponse

public struct VideoResponse: Decodable {
    let name, url: String
}

public extension VideoResponse {
    func toDomain() -> VideoEntity {
        VideoEntity(name: name, videoURLString: url)
    }
}
