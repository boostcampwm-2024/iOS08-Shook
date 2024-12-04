import Combine

import BaseDomain
import ChattingDomainInterface

public final class ChatRepositoryImpl: BaseRepository<ChatEndpoint>, ChatRepository {
    public func makeChatRoom(_ id: String) -> AnyPublisher<Void, any Error> {
        request(.makeRoom(id), type: BaseChatDTO.self)
            .map { _ in () }
            .eraseToAnyPublisher()
    }

    public func deleteChatRoom(_ id: String) -> AnyPublisher<Void, any Error> {
        request(.deleteRoom(id), type: BaseChatDTO.self)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
