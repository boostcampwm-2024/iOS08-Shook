import Combine
import Foundation

public protocol DeleteChatRoomUseCase {
    func execute(id: String) -> AnyPublisher<Void, Error>
}
