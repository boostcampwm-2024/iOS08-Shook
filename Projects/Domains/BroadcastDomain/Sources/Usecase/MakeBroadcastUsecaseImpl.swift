import Combine
import Foundation

import BroadcastDomainInterface

public struct MakeBroadcastUsecaseImpl: MakeBroadcastUsecase {
    private let repository: any BroadcastRepository

    public init(repository: any BroadcastRepository) {
        self.repository = repository
    }

    public func execute(id: String, title: String, owner: String, description: String) -> AnyPublisher<Void, any Error> {
        repository.makeBroadcast(id: id, title: title, owner: owner, description: description)
    }
}
