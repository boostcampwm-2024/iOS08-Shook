import UIKit

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
        
        let channelListUsecase = DIContainer.shared.resolve(FetchChannelListUsecase.self)
        
        let factory = DIContainer.shared.resolve(LiveStreamViewControllerFactory.self)

        let viewModel = BroadcastCollectionViewModel(usecase: channelListUsecase)
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
        let chatRepositoryImpl: any ChatRepository = ChatRepositoryImpl()
        let makeRoomUseCase: any MakeChatRoomUseCase = MakeChatRoomUseCaseImpl(repository: chatRepositoryImpl)
        let deleteRoomUseCase: any DeleteChatRoomUseCase = DeleteChatRoomUseCaseImpl(repository: chatRepositoryImpl)
        let liveStreamFactoryImpl = LiveStreamViewControllerFractoryImpl(makeChatRoomUseCase: makeRoomUseCase, deleteChatRoomUseCase: deleteRoomUseCase)
        DIContainer.shared.register(LiveStreamViewControllerFactory.self, dependency: liveStreamFactoryImpl)
        
        let liveStationRepository = LiveStationRepositoryImpl()
        let fetchChannelListUsecaseImpl = FetchChannelListUsecaseImpl(repository: liveStationRepository)
        DIContainer.shared.register(FetchChannelListUsecase.self, dependency: fetchChannelListUsecaseImpl)
    }
}
