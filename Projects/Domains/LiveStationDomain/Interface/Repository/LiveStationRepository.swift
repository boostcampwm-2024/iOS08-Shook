import Combine

public protocol LiveStationRepository {
    func fetchChannelList() -> AnyPublisher<[ChannelEntity], Error>
    func fetchThumbnail(channelId: String) -> AnyPublisher<[String], any Error>
    func receiveBroadcast(channelId: String) -> AnyPublisher<[BroadcastEntity], any Error>
    func createChannel(name: String) -> AnyPublisher<ChannelEntity, any Error>
}
