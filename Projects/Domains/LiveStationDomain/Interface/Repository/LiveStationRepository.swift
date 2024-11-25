import Combine

public protocol LiveStationRepository {
    func fetchChannelList() -> AnyPublisher<[ChannelEntity], Error>
    func fetchThumbnail(channelId: String) -> AnyPublisher<[String], any Error>
    func createChannel(name: String) -> AnyPublisher<ChannelEntity, any Error>
    func deleteChannel(id: String) -> AnyPublisher<ChannelEntity, any Error>
}
