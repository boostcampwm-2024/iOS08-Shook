import Foundation

import LiveStationDomainInterface

public struct ChannelListResponseDTO: Decodable {
    let content: [ChannelResponse]
}

public struct ChannelResponse: Decodable {
    let channelId: String
}

extension ChannelResponse {
    public func toDomain() -> ChannelEntity {
        ChannelEntity(id: self.channelId, name: self.channelId)
    }
}
