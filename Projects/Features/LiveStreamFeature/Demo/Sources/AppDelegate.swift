import UIKit

import LiveStreamFeature

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewModel = LiveStreamViewModel(channelID: "1234")
        let viewController = LiveStreamViewController(viewModel: viewModel)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        return true
    }
}
