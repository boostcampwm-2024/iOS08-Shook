import UIKit

import BaseFeatureInterface
import ChattingDomainInterface
import LiveStreamFeatureInterface

public struct LiveStreamViewControllerFractoryImpl: LiveStreamViewControllerFactory {
    
    private let us1: any MakeChatRoomUseCase
    private let us2: any DeleteChatRoomUseCase
    
    public init(us1: any MakeChatRoomUseCase, us2: DeleteChatRoomUseCase) {
        self.us1 = us1
        self.us2 = us2
    }
    
    public func make() -> UIViewController {
        let viewModel = LiveStreamViewModel(makeChatRoomUseCase: us1, deleteChatRoomUseCase: us2)
        return LiveStreamViewController(viewModel: viewModel)
    }
}
