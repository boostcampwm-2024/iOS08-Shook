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
        let fetcher = MockFetcher()
        let viewModel = BroadcastCollectionViewModel(fetcher: fetcher)
        let viewController = BroadcastCollectionViewController(viewModel: viewModel)
        viewController.view.backgroundColor = .yellow
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }
}

class MockFetcher: Fetcher {
    func fetch() -> [Item] {
        [
            Item(image: UIImage(systemName: "star.fill"),title: "hello", subtitle1: "hello", subtitle2: "hello")
        ]
    }
}
