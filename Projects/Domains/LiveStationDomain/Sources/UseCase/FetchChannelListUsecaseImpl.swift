import Combine

import LiveStationDomainInterface

struct FetchChannelListUsecaseImpl: FetchChannelListUsecase {
    private let repository: any LiveStationRepository
    
    init(repository: any LiveStationRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[ChannelEntity], any Error> {
        repository.fetchChannelList()
    }
}
