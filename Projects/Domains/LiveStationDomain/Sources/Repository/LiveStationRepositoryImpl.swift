import Combine

import BaseDomain
import LiveStationDomainInterface

public final class LiveStationRepositoryImpl: BaseRepository<LiveStationEndpoint>, LiveStationRepository {
    public func fetchChannelList() -> AnyPublisher<[ChannelEntity], any Error> {
        return request(.fetchChannelList, type: ChannelListResponseDTO.self)
            .map{ $0.content.map{ $0.toDomain() } }
            .eraseToAnyPublisher()
    }
}
