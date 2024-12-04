import Combine

import BroadcastDomainInterface

final class MockMakeBroadcastUsecaseImpl: MakeBroadcastUsecase {
    func execute(id _: String, title _: String, owner _: String, description _: String) -> AnyPublisher<Void, any Error> {
        Future { promise in
            promise(.success(()))
        }.eraseToAnyPublisher()
    }
}
