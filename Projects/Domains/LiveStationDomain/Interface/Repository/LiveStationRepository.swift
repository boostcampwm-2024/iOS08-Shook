import Combine

public protocol LiveStationRepository {
    func fetchChannelList() -> AnyPublisher<[ChannelEntity], Error>
}
