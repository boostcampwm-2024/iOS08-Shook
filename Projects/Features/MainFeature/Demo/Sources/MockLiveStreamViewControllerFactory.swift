import UIKit

import LiveStreamFeatureInterface

public struct MockLiveStreamViewControllerFractoryImpl: LiveStreamViewControllerFactory {
    public init() {}

    public func make(channelID _: String, title _: String, owner _: String, description _: String) -> UIViewController {
        let viewModel = MockLiveStreamViewModel()
        return MockLiveStreamViewController(viewModel: viewModel)
    }
}
