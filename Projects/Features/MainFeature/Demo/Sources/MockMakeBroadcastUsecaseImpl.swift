import Combine

import BroadcastDomainInterface

final class MockMakeBroadcastUsecaseImpl: MakeBroadcastUsecase {
    func execute(id: String, title: String, owner: String, description: String) -> AnyPublisher<Void, any Error> {
        Future { promise in
            promise(.success(()))
        }.eraseToAnyPublisher()
    }
}
