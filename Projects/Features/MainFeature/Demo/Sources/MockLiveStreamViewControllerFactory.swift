import UIKit

import LiveStreamFeatureInterface

public struct MockLiveStreamViewControllerFractoryImpl: LiveStreamViewControllerFactory {
    public init() { }
    
    public func make(channelID: String) -> UIViewController {
        let viewModel = MockLiveStreamViewModel()
        return MockLiveStreamViewController(viewModel: viewModel)
    }
}
