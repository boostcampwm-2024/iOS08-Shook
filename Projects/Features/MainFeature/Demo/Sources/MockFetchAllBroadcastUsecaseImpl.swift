import Combine

import BroadcastDomainInterface

final class MockFetchAllBroadcastUsecaseImpl: FetchAllBroadcastUsecase {
    func execute() -> AnyPublisher<[BroadcastInfoEntity], any Error> {
        Future { promise in
            promise(.success([.init(id: "1", title: "title", owner: "owner", description: "description")]))
        }.eraseToAnyPublisher()
    }
}
