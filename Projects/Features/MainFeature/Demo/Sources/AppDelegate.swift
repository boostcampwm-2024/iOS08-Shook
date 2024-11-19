import UIKit

import MainFeature

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewModel = BroadcastCollectionViewModel()
        let viewController = BroadcastCollectionViewController(viewModel: viewModel)
        viewController.view.backgroundColor = .yellow
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }
}
