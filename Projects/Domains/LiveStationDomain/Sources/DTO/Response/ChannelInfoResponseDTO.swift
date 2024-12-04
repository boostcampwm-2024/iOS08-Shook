import LiveStationDomainInterface

struct ChannelInfoResponseDTO: Decodable {
    struct ContentResponseDTO: Decodable {
        let channelId: String
        let channelName: String
        let streamKey: String
        let publishUrl: String
    }

    let content: ContentResponseDTO

    var toDomain: ChannelInfoEntity {
        ChannelInfoEntity(
            id: content.channelId,
            name: content.channelName,
            streamKey: content.streamKey,
            rtmpUrl: content.publishUrl
        )
    }
}
