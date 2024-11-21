import Combine

import BaseDomain
import LiveStationDomainInterface

final class LiveStationRepositoryImpl: BaseRepository<LiveStationEndpoint>, LiveStationRepository {
    func fetchChannelList() -> AnyPublisher<[ChannelEntity], any Error> {
        return request(.fetchChannelList, type: ChannelListResponseDTO.self)
            .map{ $0.content.map{ $0.toDomain() } }
            .eraseToAnyPublisher()
    }
}
