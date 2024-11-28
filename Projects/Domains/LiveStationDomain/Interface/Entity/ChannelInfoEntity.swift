public struct ChannelInfoEntity {
    public let id: String
    public let name: String
    public let streamKey: String
    public let rtmpUrl: String
    
    public init(id: String, name: String, streamKey: String, rtmpUrl: String) {
        self.id = id
        self.name = name
        self.streamKey = streamKey
        self.rtmpUrl = rtmpUrl
    }
}
