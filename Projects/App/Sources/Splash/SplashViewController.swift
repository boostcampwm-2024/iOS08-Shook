import Combine
import UIKit

import AuthFeature
import BaseFeature
import BaseFeatureInterface
import BroadcastDomainInterface
import DesignSystem
import EasyLayout
import LiveStationDomainInterface
import LiveStreamFeatureInterface
import Lottie
import MainFeature
import MainFeatureInterface

public final class SplashViewController: BaseViewController<EmptyViewModel> {
    private let splashGradientView = SplashGradientView()
    private let splashAnimationView = LottieAnimationView(name: "splash", bundle: Bundle(for: DesignSystemResources.self))
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        splashAnimationView.play { [weak self] _ in
            self?.moveToMainView()
        }
    }
    
    public override func setupViews() {
        view.addSubview(splashGradientView)
        view.addSubview(splashAnimationView)
    }
    
    public override func setupLayouts() {
        splashGradientView.ezl.makeConstraint {
            $0.diagonal(to: view)
        }
        
        splashAnimationView.ezl.makeConstraint {
            $0.diagonal(to: view)
        }
    }
}

// MARK: - View Transition
extension SplashViewController {
    private func moveToMainView() {
        let fetchChannelListUsecase = DIContainer.shared.resolve(FetchChannelListUsecase.self)
        let fetchAllBroadcastUsecase = DIContainer.shared.resolve(FetchAllBroadcastUsecase.self)
        let factory = DIContainer.shared.resolve(LiveStreamViewControllerFactory.self)
        let settingFactory = DIContainer.shared.resolve(SettingViewControllerFactory.self)
        let broadcastFactory = DIContainer.shared.resolve(BroadcastViewControllerFactory.self)
        let viewModel = BroadcastCollectionViewModel(
            fetchChannelListUsecase: fetchChannelListUsecase,
            fetchAllBroadcastUsecase: fetchAllBroadcastUsecase
        )
        let viewController = BroadcastCollectionViewController(viewModel: viewModel, factory: factory, settingFactory: settingFactory, broadcastFactory: broadcastFactory)
        let navigationController = BaseNavigationController(rootViewController: viewController)
        let createChannelUsecase = DIContainer.shared.resolve(CreateChannelUsecase.self)

        /// 유저의 이름이 저장되어 있지 않으면 유저 등록 뷰를 Navigation에 올림
        if UserDefaults.standard.string(forKey: "USER_NAME") == nil {
            let singUpViewModel = SignUpViewModel(createChannelUsecase: createChannelUsecase)
            navigationController.viewControllers.append(SignUpViewController(viewModel: singUpViewModel))
        }
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve) {
            window.rootViewController = navigationController
        }
    }
}
