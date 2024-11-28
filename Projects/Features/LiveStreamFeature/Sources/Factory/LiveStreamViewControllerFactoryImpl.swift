import UIKit

import BaseFeatureInterface
import LiveStationDomainInterface
import LiveStreamFeatureInterface

public struct LiveStreamViewControllerFactoryImpl: LiveStreamViewControllerFactory {
    private let fetchBroadcastUseCase: any FetchVideoListUsecase
    
    public init(
        fetchBroadcastUseCase: any FetchVideoListUsecase
    ) {
        self.fetchBroadcastUseCase = fetchBroadcastUseCase
    }
    
    public func make(channelID: String) -> UIViewController {
        let viewModel = LiveStreamViewModel(channelID: channelID, fetchVideoListUsecase: fetchBroadcastUseCase)
        return LiveStreamViewController(viewModel: viewModel)
    }
}
