import LiveStationDomainInterface

// MARK: - BroadcastResponseDTO

public struct BroadcastResponseDTO: Decodable {
    let content: [BroadcastResponse]
}

// MARK: - BroadcastResponse

public struct BroadcastResponse: Decodable {
    let name, url, resolution, videoBitrate, audioBitrate: String
}

public extension BroadcastResponse {
    func toDomain() -> BroadcastEntity {
        BroadcastEntity(name: name, urlString: url)
    }
}
