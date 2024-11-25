import UIKit

import LiveStationDomain
import LiveStationDomainInterface
import LiveStreamFeature
import LiveStreamFeatureInterface
import MainFeature
import ThirdPartyLibModule

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        registerDependencies()

        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        
        let usecase = DIContainer.shared.resolve(FetchChannelListUsecase.self)
        let factory = DIContainer.shared.resolve(LiveStreamViewControllerFactory.self)

        let mockUsecase = MockFetchChannelListUsecaseImpl()
        let viewModel = BroadcastCollectionViewModel(usecase: mockUsecase)
        let viewController = BroadcastCollectionViewController(viewModel: viewModel, factory: factory)
        self.window?.rootViewController = UINavigationController(rootViewController: viewController)
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}

    // MARK: - Handling DeepLink
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {}

    // MARK: - Handling UniversalLink
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {}
}

extension SceneDelegate {
    private func registerDependencies() {
        let liveStreamFactoryImpl = LiveStreamViewControllerFractoryImpl()
        DIContainer.shared.register(LiveStreamViewControllerFactory.self, dependency: liveStreamFactoryImpl)
        
        let liveStationRepository = LiveStationRepositoryImpl()
        let fetchChannelListUsecase = FetchChannelListUsecaseImpl(repository: liveStationRepository)
        DIContainer.shared.register(FetchChannelListUsecase.self, dependency: fetchChannelListUsecase)
    }
}
