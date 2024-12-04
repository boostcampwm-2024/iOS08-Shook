import Combine
import Foundation

import ChattingDomainInterface

public struct DeleteChatRoomUseCaseImpl: DeleteChatRoomUseCase {
    private let repository: any ChatRepository

    public init(repository: any ChatRepository) {
        self.repository = repository
    }

    public func execute(id: String) -> AnyPublisher<Void, Error> {
        repository.deleteChatRoom(id)
    }
}
