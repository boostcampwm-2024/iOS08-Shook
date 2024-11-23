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
        let mockUsecase = MockFetchChannelListUsecaseImpl()
        let viewModel = BroadcastCollectionViewModel(usecase: mockUsecase)
        let mockFactory = MockLiveStreamViewControllerFractoryImpl()
        
        let viewController = BroadcastCollectionViewController(viewModel: viewModel, factory: mockFactory)
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}
