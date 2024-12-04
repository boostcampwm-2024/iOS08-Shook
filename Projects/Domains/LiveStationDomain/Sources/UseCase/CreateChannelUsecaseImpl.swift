import Combine

import LiveStationDomainInterface

public struct CreateChannelUsecaseImpl: CreateChannelUsecase {
    private let repository: LiveStationRepository

    public init(repository: LiveStationRepository) {
        self.repository = repository
    }

    public func execute(name: String) -> AnyPublisher<ChannelEntity, Error> {
        repository.createChannel(name: name)
    }
}
