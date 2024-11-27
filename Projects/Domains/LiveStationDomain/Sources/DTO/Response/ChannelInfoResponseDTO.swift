import LiveStationDomainInterface

struct ChannelInfoResponseDTO: Decodable {
    let channelId: String
    let channelName: String
    let streamKey: String
    let publishUrl: String
    
    var toDomain: ChannelInfoEntity {
        ChannelInfoEntity(id: channelId, name: channelName, streamKey: streamKey, rtmpUrl: publishUrl)
    }
}
