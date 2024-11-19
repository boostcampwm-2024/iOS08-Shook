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
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

class MockFetcher: Fetcher {
    func fetch() -> [Item] {
        [
            Item(image: UIImage(systemName: "star.fill"), title: "hello1", subtitle1: "hello", subtitle2: "hello"),
            Item(image: UIImage(systemName: "star.fill"), title: "hello2", subtitle1: "hello", subtitle2: "hello"),
            Item(image: UIImage(systemName: "star.fill"), title: "hello3", subtitle1: "hello", subtitle2: "hello"),
            Item(image: UIImage(systemName: "star.fill"), title: "hello3", subtitle1: "hello", subtitle2: "hello"),
            Item(image: UIImage(systemName: "star.fill"), title: "hello3", subtitle1: "hello", subtitle2: "hello")
        ]
    }
}
