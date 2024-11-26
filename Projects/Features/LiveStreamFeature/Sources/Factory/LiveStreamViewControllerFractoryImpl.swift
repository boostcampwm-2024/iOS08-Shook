import UIKit

import BaseFeatureInterface
import ChattingDomainInterface
import LiveStreamFeatureInterface

public struct LiveStreamViewControllerFractoryImpl: LiveStreamViewControllerFactory {
    
    public func make(channelID: String) -> UIViewController {
        let viewModel = LiveStreamViewModel(channelID: channelID)
        return LiveStreamViewController(viewModel: viewModel)
    }
}
