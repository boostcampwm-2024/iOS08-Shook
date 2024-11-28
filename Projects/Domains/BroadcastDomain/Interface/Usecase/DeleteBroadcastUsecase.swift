import Combine
import Foundation

public protocol DeleteBroadcastUsecase {
    func execute(id: String) -> AnyPublisher<Void, Error>
}
