import LiveStationDomainInterface

public struct BroadcastResponseDTO: Decodable {
    let content: [BroadcastResponse]
}

public struct BroadcastResponse: Decodable {
    let name, url, resolution, videoBitrate, audioBitrate: String
}

extension BroadcastResponse {
    public func toDomain() -> BroadcastEntity {
        BroadcastEntity(name: self.name, urlString: self.url)
    }
}
