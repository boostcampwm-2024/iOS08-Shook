import ReplayKit
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
        let mockFetchChannelListUsecase = MockFetchChannelListUsecaseImpl()
        let mockCreateChannelUsecase = MockCreateChannelUsecaseImpl()
        let mockDeleteChannelUsecase = MockDeleteChannelUsecaseImpl()
        let mockFetchChannelInfoUsecase = MockFetchChannelInfoUsecaseImpl()
        let mockMakeChatRoomUseCase = MockMakeChatRoomUseCaseImpl()
        let viewModel = BroadcastCollectionViewModel(
            fetchChannelListUsecase: mockFetchChannelListUsecase,
            createChannelUsecase: mockCreateChannelUsecase,
            deleteChannelUsecase: mockDeleteChannelUsecase,
            fetchChannelInfoUsecase: mockFetchChannelInfoUsecase,
            makeChatRoomUsecase: mockMakeChatRoomUseCase
        )
        let mockFactory = MockLiveStreamViewControllerFractoryImpl()
        let viewController = BroadcastCollectionViewController(viewModel: viewModel, factory: mockFactory)
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}
