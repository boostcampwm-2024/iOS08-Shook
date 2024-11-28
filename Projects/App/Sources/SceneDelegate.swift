import UIKit

import BroadcastDomain
import BroadcastDomainInterface
import ChattingDomain
import ChattingDomainInterface
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
        let viewModel = SplashViewModel()
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
        
        let fetchChannelInfoUsecaseImpl = FetchChannelInfoUsecaseImpl(repository: liveStationRepository)
        DIContainer.shared.register(FetchChannelInfoUsecase.self, dependency: fetchChannelInfoUsecaseImpl)
        
        let broadcastRepository = BroadcastRepositoryImpl()
        let deleteBroadCastUsecaseImpl = DeleteBroadcastUsecaseImpl(repository: broadcastRepository)
        DIContainer.shared.register(DeleteBroadcastUsecase.self, dependency: deleteBroadCastUsecaseImpl)

        let chatRepository = ChatRepositoryImpl()
        let makeChatRoomUsecaseImpl = MakeChatRoomUseCaseImpl(repository: chatRepository)
        DIContainer.shared.register(MakeChatRoomUseCase.self, dependency: makeChatRoomUsecaseImpl)
        
        let fetchBroadcastUseCase: any FetchVideoListUsecase = FetchVideoListUsecaseImpl(repository: liveStationRepository)
        let liveStreamFactoryImpl = LiveStreamViewControllerFactoryImpl(fetchBroadcastUseCase: fetchBroadcastUseCase)
        DIContainer.shared.register(LiveStreamViewControllerFactory.self, dependency: liveStreamFactoryImpl)
    }
}
