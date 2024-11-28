import Combine

import LiveStationDomainInterface

final class MockDeleteChannelUsecaseImpl: DeleteChannelUsecase {
    func execute(channelID: String) -> AnyPublisher<Void, any Error> {
        Future { promise in
            promise(.success(()))
        }.eraseToAnyPublisher()
    }
}
