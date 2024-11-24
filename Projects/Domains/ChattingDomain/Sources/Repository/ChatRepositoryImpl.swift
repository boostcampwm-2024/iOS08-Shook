import Combine

import BaseDomain
import ChattingDomainInterface

final class ChatRepositoryImpl: BaseRepository<ChatEndpoint>, ChatRepository {
    func makeChatRoom(_ id: String) -> AnyPublisher<Void, any Error> {
        request(.makeRoom(id), type: String.self)
            .map { _ in () }
            .eraseToAnyPublisher()
        
    }
    
    func deleteChatRoom(_ id: String) -> AnyPublisher<Void, any Error> {
        request(.deleteRoom(id), type: String.self)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
