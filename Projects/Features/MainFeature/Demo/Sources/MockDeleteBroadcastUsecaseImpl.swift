import Combine

import BroadcastDomainInterface

final class MockDeleteBroadcastUsecaseImpl: DeleteBroadcastUsecase {
    func execute(id _: String) -> AnyPublisher<Void, any Error> {
        Future { promise in
            promise(.success(()))
        }.eraseToAnyPublisher()
    }
}
