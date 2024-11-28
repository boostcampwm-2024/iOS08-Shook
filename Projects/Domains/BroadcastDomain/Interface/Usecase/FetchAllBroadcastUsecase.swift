import Combine
import Foundation

public protocol FetchAllBroadcastUsecase {
    func execute() -> AnyPublisher<[BroadcastInfoEntity], Error>
}
