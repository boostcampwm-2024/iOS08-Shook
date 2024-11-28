import Combine

import LiveStationDomainInterface

final class MockCreateChannelUsecaseImpl: CreateChannelUsecase {
    func execute(name: String) -> AnyPublisher<ChannelEntity, any Error> {
        Future { promise in
            promise(.success(ChannelEntity(id: "", name: name)))
        }.eraseToAnyPublisher()
    }
}
