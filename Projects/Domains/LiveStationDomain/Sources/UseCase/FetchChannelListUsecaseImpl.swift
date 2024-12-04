import Combine

import LiveStationDomainInterface

public struct FetchChannelListUsecaseImpl: FetchChannelListUsecase {
    private let repository: any LiveStationRepository

    public init(repository: any LiveStationRepository) {
        self.repository = repository
    }

    public func execute() -> AnyPublisher<[ChannelEntity], any Error> {
        repository.fetchChannelList()
            .flatMap(processChannelEntities)
            .eraseToAnyPublisher()
    }

    private func processChannelEntities(_ channelEntities: [ChannelEntity]) -> AnyPublisher<[ChannelEntity], any Error> {
        let channels = channelEntities.map { channel in
            repository.fetchThumbnail(channelId: channel.id)
                .map { thumbnail -> ChannelEntity in
                    var updatedChannel = channel
                    updatedChannel.imageURLString = thumbnail
                    return updatedChannel
                }
                .eraseToAnyPublisher()
        }

        return Publishers.MergeMany(channels)
            .collect()
            .eraseToAnyPublisher()
    }
}
