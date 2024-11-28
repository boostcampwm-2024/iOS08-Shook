import LiveStationDomainInterface

public struct ChannelResponseDTO: Decodable {
    let content: ChannelContentResponseDTO
}

public struct ChannelContentResponseDTO: Decodable {
    let channelId: String
    let channelName: String
}

extension ChannelContentResponseDTO {
    public func toDomain() -> ChannelEntity {
        ChannelEntity(id: self.channelId, name: self.channelName)
    }
}
