import Combine
import Foundation

import ChattingDomainInterface

public struct MakeChatRoomUseCaseImpl: MakeChatRoomUseCase {
    
    private let repository: any ChatRepository
    
    public func execute(id: String) -> AnyPublisher<Void, Error> {
        repository.makeChatRoom(id)
    }
    
}
