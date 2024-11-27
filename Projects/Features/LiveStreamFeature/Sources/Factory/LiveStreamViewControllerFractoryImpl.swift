import UIKit

import BaseFeatureInterface
import ChattingDomainInterface
import LiveStationDomainInterface
import LiveStreamFeatureInterface

public struct LiveStreamViewControllerFractoryImpl: LiveStreamViewControllerFactory {
    private let makeChatRoomUseCase: any MakeChatRoomUseCase
    private let deleteChatRoomUseCase: any DeleteChatRoomUseCase
    private let fetchBroadcastUseCase: any FetchVideoListUsecase
    
    public init(
        makeChatRoomUseCase: any MakeChatRoomUseCase,
        deleteChatRoomUseCase: DeleteChatRoomUseCase,
        fetchBroadcastUseCase: any FetchVideoListUsecase
    ) {
        self.makeChatRoomUseCase = makeChatRoomUseCase
        self.deleteChatRoomUseCase = deleteChatRoomUseCase
        self.fetchBroadcastUseCase = fetchBroadcastUseCase
    }
    
    public func make(channelID: String) -> UIViewController {
        let viewModel = LiveStreamViewModel(makeChatRoomUseCase: makeChatRoomUseCase, deleteChatRoomUseCase: deleteChatRoomUseCase, fetchBroadcastUseCase: fetchBroadcastUseCase, channelID: channelID)
        return LiveStreamViewController(viewModel: viewModel)
    }
}
