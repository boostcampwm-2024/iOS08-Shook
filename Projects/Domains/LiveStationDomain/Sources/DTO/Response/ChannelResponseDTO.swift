import LiveStationDomainInterface

public struct ChannelResponseDTO: Decodable {
    struct ContentResponseDTO: Decodable {
        let channelId: String
        let channelName: String
    }
    
    let content: ContentResponseDTO
}

extension ChannelResponseDTO {
    public func toDomain() -> ChannelEntity {
        ChannelEntity(id: self.content.channelId, name: self.content.channelName)
    }
}
