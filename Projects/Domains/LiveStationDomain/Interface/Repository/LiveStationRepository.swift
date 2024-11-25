import Combine

public protocol LiveStationRepository {
    func fetchChannelList() -> AnyPublisher<[ChannelEntity], Error>
    func fetchThumbnail(channelId: String) -> AnyPublisher<[String], any Error>
}
