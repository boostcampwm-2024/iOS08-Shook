import Combine

import BroadcastDomainInterface

final class MockDeleteBroadcastUsecase: DeleteBroadcastUsecase {
    func execute(id: String) -> AnyPublisher<Void, any Error> {
        Future { promise in
            promise(.success(()))
        }.eraseToAnyPublisher()
    }
}
