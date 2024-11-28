import Combine

import BaseDomain
import BroadcastDomainInterface

public final class BroadcastRepositoryImpl: BaseRepository<BroadcastEndpoint>, BroadcastRepository {
    public func makeBroadcast(id: String, title: String, owner: String, description: String) -> AnyPublisher<Void, any Error> {
        request(.make(id: id, title: title, owner: owner, description: description), type: BroadcastDTO.self)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    public func fetchAllBroadcast() -> AnyPublisher<[BroadcastInfoEntity], any Error> {
        request(.fetchAll, type: [BroadcastDTO].self)
            .map { $0.map { BroadcastInfoEntity(id: $0.id, title: $0.title, owner: $0.owner, description: $0.description) } }
            .eraseToAnyPublisher()
    }
    
    public func deleteBroadcast(id: String) -> AnyPublisher<Void, any Error> {
        request(.delete(id: id), type: BroadcastDTO.self)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
