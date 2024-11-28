import Combine

import LiveStationDomainInterface

final class MockFetchChannelInfoUsecaseImpl: FetchChannelInfoUsecase {
    func execute(channelID: String) -> AnyPublisher<ChannelInfoEntity, any Error> {
        Future { promise in
            promise(.success(ChannelInfoEntity(id: channelID, name: "", streamKey: "", rtmpUrl: "")))
        }.eraseToAnyPublisher()
    }
}
