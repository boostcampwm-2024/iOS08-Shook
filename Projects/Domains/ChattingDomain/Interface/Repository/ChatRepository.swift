import Combine
import Foundation

public protocol ChatRepository {
    func makeChatRoom(_ id: String) -> AnyPublisher<Void, Error>
    func deleteChatRoom(_ id: String) -> AnyPublisher<Void, Error>
}
