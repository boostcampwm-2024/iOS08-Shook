import Combine

import ChattingDomainInterface

final class MockMakeChatRoomUseCaseImpl: MakeChatRoomUseCase {
    func execute(id: String) -> AnyPublisher<Void, Error> {
        Future { promise in
            promise(.success(()))
        }.eraseToAnyPublisher()
    }
}
