import Combine

import LiveStationDomainInterface

public struct FetchVideoListUsecaseImpl: FetchVideoListUsecase {
    private let repository: any LiveStationRepository
    
    public init(repository: any LiveStationRepository) {
        self.repository = repository
    }
    
    public func execute(channelID: String) -> AnyPublisher<[VideoEntity], any Error> {
        repository.fetchBroadcast(channelId: channelID)
    }
}
