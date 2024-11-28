import Combine

import LiveStationDomainInterface

public struct DeleteChannelUsecaseImpl: DeleteChannelUsecase {
    private let repository: LiveStationRepository
    
    public init(repository: LiveStationRepository) {
        self.repository = repository
    }
    
    public func execute(channelID: String) -> AnyPublisher<Void, any Error> {
        repository.deleteChannel(id: channelID)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
