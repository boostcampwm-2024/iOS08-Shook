import Combine

import BaseDomain
import LiveStationDomainInterface

public final class LiveStationRepositoryImpl: BaseRepository<LiveStationEndpoint>, LiveStationRepository {
    public func fetchChannelList() -> AnyPublisher<[ChannelEntity], any Error> {
        return request(.fetchChannelList, type: ChannelListResponseDTO.self)
            .map { $0.content.map { $0.toDomain() }}
            .eraseToAnyPublisher()
    }
    
    public func fetchThumbnail(channelId: String) -> AnyPublisher<String, any Error> {
        return request(.fetchThumbnail(channelId: channelId), type: ThumbnailResponseDTO.self)
            .compactMap { $0.content.first?.toDomain() }
            .eraseToAnyPublisher()
    }
    
    public func fetchBroadcast(channelId: String) -> AnyPublisher<[VideoEntity], any Error> {
        return request(.receiveBroadcast(channelId: channelId), type: VideoListResponseDTO.self)
            .map { $0.content.map { $0.toDomain() }}
            .eraseToAnyPublisher()
    }
  
    public func createChannel(name: String) -> AnyPublisher<ChannelEntity, any Error> {
        return request(.makeChannel(channelName: name), type: ChannelResponseDTO.self)
            .map { $0.content.toDomain() }
            .eraseToAnyPublisher()
    }
    
    public func deleteChannel(id: String) -> AnyPublisher<ChannelEntity, any Error> {
        return request(.deleteChannel(channelId: id), type: ChannelResponseDTO.self)
            .map { $0.content.toDomain() }
            .eraseToAnyPublisher()
    }
    
    public func fetchChannelInfo(id: String) -> AnyPublisher<ChannelInfoEntity, any Error> {
        return request(.fetchChannelInfo(channelId: id), type: ChannelInfoResponseDTO.self)
            .map { $0.toDomain }
            .eraseToAnyPublisher()
    }
}
