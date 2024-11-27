import LiveStationDomainInterface

public struct VideoListResponseDTO: Decodable {
    let content: [VideoResponse]
}

public struct VideoResponse: Decodable {
    let name, url: String
}

extension VideoResponse {
    public func toDomain() -> VideoEntity {
        VideoEntity(name: self.name, videoURLString: self.url)
    }
}
