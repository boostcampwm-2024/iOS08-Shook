import Combine
import Foundation

public protocol BroadcastRepository {
    func makeBroadcast(id: String, title: String, owner: String, description: String) -> AnyPublisher<Void, Error>
    func fetchAllBroadcast() -> AnyPublisher<[BroadcastInfoEntity], Error>
    func deleteBroadcast(id: String) -> AnyPublisher<Void, Error>
}
