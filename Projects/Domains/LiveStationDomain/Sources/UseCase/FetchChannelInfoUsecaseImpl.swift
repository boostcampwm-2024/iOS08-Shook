import Combine

import LiveStationDomainInterface

public struct FetchChannelInfoUsecaseImpl: FetchChannelInfoUsecase {
    private let repository: any LiveStationRepository
    
    public init(repository: any LiveStationRepository) {
        self.repository = repository
    }
    
    public func execute(channelID: String) -> AnyPublisher<ChannelInfoEntity, any Error> {
        repository.fetchChannelInfo(id: channelID)
    }
}
