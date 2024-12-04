import ReplayKit
import UIKit

import MainFeature

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let mockFetchChannelListUsecase = MockFetchChannelListUsecaseImpl()
        let mockFetchChannelInfoUsecase = MockFetchChannelInfoUsecaseImpl()
        let mockmakeBroadcastUsecase = MockMakeBroadcastUsecaseImpl()
        let mockFetchAllBroadcastUsecase = MockFetchAllBroadcastUsecaseImpl()
        let mockDeleteBroadcastUsecase = MockDeleteBroadcastUsecaseImpl()
        let viewModel = BroadcastCollectionViewModel(
            fetchChannelListUsecase: mockFetchChannelListUsecase,
            fetchAllBroadcastUsecase: mockFetchAllBroadcastUsecase
        )
        let mockFactory = MockLiveStreamViewControllerFractoryImpl()
        let viewController = BroadcastCollectionViewController(viewModel: viewModel, factory: mockFactory)
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}
