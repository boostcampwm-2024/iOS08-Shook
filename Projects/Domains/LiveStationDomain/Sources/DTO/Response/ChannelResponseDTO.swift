import LiveStationDomainInterface

public struct ChannelResponseDTO: Decodable {
    let content: ContentResponseDTO
}

public struct ContentResponseDTO: Decodable {
    let channelId: String
    let channelName: String
}

extension ContentResponseDTO {
    public func toDomain() -> ChannelEntity {
        ChannelEntity(id: self.channelId, name: self.channelName)
    }
}
