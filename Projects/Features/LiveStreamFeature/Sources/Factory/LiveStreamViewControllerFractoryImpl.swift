import UIKit

import BaseFeatureInterface
import ChattingDomainInterface
import LiveStreamFeatureInterface

public struct LiveStreamViewControllerFractoryImpl: LiveStreamViewControllerFactory {
    
    private let makeChatRoomUseCase: any MakeChatRoomUseCase
    private let deleteChatRoomUseCase: any DeleteChatRoomUseCase
    
    public init(makeChatRoomUseCase: any MakeChatRoomUseCase, deleteChatRoomUseCase: DeleteChatRoomUseCase) {
        self.makeChatRoomUseCase = makeChatRoomUseCase
        self.deleteChatRoomUseCase = deleteChatRoomUseCase
    }
    
    public func make(channelID: String) -> UIViewController {
        let viewModel = LiveStreamViewModel(channelID: channelID, makeChatRoomUseCase: makeChatRoomUseCase, deleteChatRoomUseCase: deleteChatRoomUseCase)
        return LiveStreamViewController(viewModel: viewModel)
    }
}
