import UIKit

import LiveStreamFeatureInterface

public struct LiveStreamViewControllerFractoryImpl: LiveStreamViewControllerFactory {
    public init() { }
    
    public func make() -> UIViewController {
        let viewModel = LiveStreamViewModel()
        return LiveStreamViewController(viewModel: viewModel)
    }
}
