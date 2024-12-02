import UIKit

import BroadcastDomain
import BroadcastDomainInterface
import LiveStationDomain
import LiveStationDomainInterface
import LiveStreamFeature
import LiveStreamFeatureInterface
import MainFeature
import MainFeatureInterface
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
        let viewModel = EmptyViewModel()
        self.window?.rootViewController = SplashViewController(viewModel: viewModel)
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
        let liveStationRepository = LiveStationRepositoryImpl()
        let fetchChannelListUsecaseImpl = FetchChannelListUsecaseImpl(repository: liveStationRepository)
        DIContainer.shared.register(FetchChannelListUsecase.self, dependency: fetchChannelListUsecaseImpl)
        
        let createChannelUsecaseImpl = CreateChannelUsecaseImpl(repository: liveStationRepository)
        DIContainer.shared.register(CreateChannelUsecase.self, dependency: createChannelUsecaseImpl)
        
        let deleteChannelUsecaseImpl = DeleteChannelUsecaseImpl(repository: liveStationRepository)
        DIContainer.shared.register(DeleteChannelUsecase.self, dependency: deleteChannelUsecaseImpl)
        
        let fetchChannelInfoUsecaseImpl: any FetchChannelInfoUsecase = FetchChannelInfoUsecaseImpl(repository: liveStationRepository)
        DIContainer.shared.register(FetchChannelInfoUsecase.self, dependency: fetchChannelInfoUsecaseImpl)
        
        let broadcastRepository = BroadcastRepositoryImpl()
        let makeBroadcastUsecaseImpl: any MakeBroadcastUsecase = MakeBroadcastUsecaseImpl(repository: broadcastRepository)
        let fetchAllBroadcastUsecaseImpl = FetchAllBroadcastUsecaseImpl(repository: broadcastRepository)
        let deleteBroadCastUsecaseImpl: DeleteBroadcastUsecase = DeleteBroadcastUsecaseImpl(repository: broadcastRepository)
        DIContainer.shared.register(MakeBroadcastUsecase.self, dependency: makeBroadcastUsecaseImpl)
        DIContainer.shared.register(FetchAllBroadcastUsecase.self, dependency: fetchAllBroadcastUsecaseImpl)
        DIContainer.shared.register(DeleteBroadcastUsecase.self, dependency: deleteBroadCastUsecaseImpl)

        let fetchBroadcastUseCase: any FetchVideoListUsecase = FetchVideoListUsecaseImpl(repository: liveStationRepository)
        let liveStreamFactoryImpl = LiveStreamViewControllerFactoryImpl(fetchBroadcastUseCase: fetchBroadcastUseCase)
        DIContainer.shared.register(LiveStreamViewControllerFactory.self, dependency: liveStreamFactoryImpl)
        
        let broadcastState: BroadcastState = BroadcastState.shared
        
        let settingFactoryImpl = SettingViewControllerFactoryImpl(
            fetchChannelInfoUsecase: fetchChannelInfoUsecaseImpl,
            makeBroadcastUsecase: makeBroadcastUsecaseImpl,
            deleteBroadCastUsecase: deleteBroadCastUsecaseImpl,
            broadcastState: broadcastState
        )
        DIContainer.shared.register(SettingViewControllerFactory.self, dependency: settingFactoryImpl)
        
        let broadcastViewControllerFactory = BroadcastViewControllerFactoryImpl(
            fetchChannelInfoUsecase: fetchChannelInfoUsecaseImpl,
            makeBroadcastUsecase: makeBroadcastUsecaseImpl,
            deleteBroadCastUsecase: deleteBroadCastUsecaseImpl,
            broadcastState: broadcastState
        )
        DIContainer.shared.register(BroadcastViewControllerFactory.self, dependency: broadcastViewControllerFactory)
    }
}
