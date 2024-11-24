import Combine
import Foundation

public protocol MakeChatRoomUseCase {
    func execute(id: String) -> AnyPublisher<Void, Error>
}
