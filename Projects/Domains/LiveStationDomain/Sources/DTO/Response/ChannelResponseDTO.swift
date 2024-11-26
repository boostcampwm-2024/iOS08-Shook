import LiveStationDomainInterface

public struct ChannelResponseDTO: Decodable {
    let channelId: String
    let channelName: String
}

extension ChannelResponseDTO {
    public func toDomain() -> ChannelEntity {
        ChannelEntity(id: self.channelId, name: self.channelName)
    }
}
