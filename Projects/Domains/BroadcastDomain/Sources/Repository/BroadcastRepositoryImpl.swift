import Combine

import BaseDomain
import BroadcastDomainInterface

public final class BroadcastRepositoryImpl: BaseRepository<BroadcastEndpoint> {
    public func makeBroadcast(id: String, title: String, owner: String, description: String) -> AnyPublisher<Void, any Error> {
        request(.broadcast(id: id, title: title, owner: owner, description: description), type: BroadcastDTO.self)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    public func fetchAllBroadcast() -> AnyPublisher<[BroadcastEntity], any Error> {
        request(.all, type: [BroadcastDTO].self)
            .map { $0.map { BroadcastEntity(title: $0.title, owner: $0.owner, description: $0.description) } }
            .eraseToAnyPublisher()
    }
    
    public func deleteBroadcast(id: String) -> AnyPublisher<Void, any Error> {
        request(.delete(id: id), type: BroadcastDTO.self)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
