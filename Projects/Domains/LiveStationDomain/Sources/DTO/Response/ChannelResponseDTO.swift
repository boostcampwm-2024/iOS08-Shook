import LiveStationDomainInterface

// MARK: - ChannelResponseDTO

public struct ChannelResponseDTO: Decodable {
    let content: ChannelContentResponseDTO
}

// MARK: - ChannelContentResponseDTO

public struct ChannelContentResponseDTO: Decodable {
    let channelId: String
    let channelName: String
}

public extension ChannelContentResponseDTO {
    func toDomain() -> ChannelEntity {
        ChannelEntity(id: channelId, name: channelName)
    }
}
