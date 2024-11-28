import Combine
import Foundation

public protocol MakeBroadcastUsecase {
    func execute(id: String, title: String, owner: String, description: String) -> AnyPublisher<Void, Error>
}
