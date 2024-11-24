import UIKit

import ChattingDomain
import ChattingDomainInterface
import MainFeature
import LiveStreamFeature
import LiveStreamFeatureInterface
import ThirdPartyLibModule


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        let vc = UIViewController()
        vc.view.backgroundColor = .orange
        self.window?.rootViewController = vc
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
        let liveStreamFactoryImpl = LiveStreamViewControllerFractoryImpl()
        DIContainer.shared.register(LiveStreamViewControllerFactory.self, dependency: liveStreamFactoryImpl)
        
        DIContainer.shared.register(MakeChatRoomUseCase.self, dependency: makeRoomUseCase)
        DIContainer.shared.register(DeleteChatRoomUseCase.self, dependency: deleteRoomUseCase)
    
    }
}
