import UIKit

import LiveStreamFeatureInterface

public struct MockLiveStreamViewControllerFractoryImpl: LiveStreamViewControllerFactory {    
    public init() { }
    
    public func make(channelID: String, title: String, owner: String, description: String) -> UIViewController {
        let viewModel = MockLiveStreamViewModel()
        return MockLiveStreamViewController(viewModel: viewModel)
    }
}
