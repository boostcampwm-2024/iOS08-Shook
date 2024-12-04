import Combine
import Foundation

import BroadcastDomainInterface

public struct DeleteBroadcastUsecaseImpl: DeleteBroadcastUsecase {
    private let repository: any BroadcastRepository

    public init(repository: any BroadcastRepository) {
        self.repository = repository
    }

    public func execute(id: String) -> AnyPublisher<Void, Error> {
        repository.deleteBroadcast(id: id)
    }
}
