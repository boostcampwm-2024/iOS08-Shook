import Combine

import LiveStationDomainInterface

public struct FetchChannelListUsecaseImpl: FetchChannelListUsecase {
    private let repository: any LiveStationRepository
    
    public init(repository: any LiveStationRepository) {
        self.repository = repository
    }
    
    public func execute() -> AnyPublisher<[ChannelEntity], any Error> {
        repository.fetchChannelList()
    }
}
