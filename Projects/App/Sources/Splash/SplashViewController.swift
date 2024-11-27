import Combine
import UIKit

import AuthFeature
import BaseFeature
import BaseFeatureInterface
import DesignSystem
import EasyLayoutModule
import LiveStationDomainInterface
import LiveStreamFeatureInterface
import MainFeature

public final class SplashViewController: BaseViewController<SplashViewModel> {
    private let splashGradientView = SplashGradientView()
    private let logoImageView = UIImageView()
    private var subscriptions = Set<AnyCancellable>()
    
    @Published private var viewDidLoadPublisher: Void?
    
    lazy var input = SplashViewModel.Input(viewDidLoad: $viewDidLoadPublisher.eraseToAnyPublisher())
    lazy var output = viewModel.transform(input: input)
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadPublisher = ()
    }
    
    public override func setupViews() {
        view.addSubview(splashGradientView)
        view.addSubview(logoImageView)
    }
    
    public override func setupStyles() {
        logoImageView.image = DesignSystemAsset.Image.mainLogo.image
        logoImageView.contentMode = .scaleAspectFit
    }
    
    public override func setupLayouts() {
        let screenWidth = getScreenWidth()
        let length = screenWidth / 1.5
        logoImageView.frame = CGRect(x: -length + 50, y: view.center.y - (length/2), width: length, height: length) // 화면 왼쪽에서 시작
        
        splashGradientView.ezl.makeConstraint {
            $0.diagonal(to: view)
        }
    }
    
    public override func setupBind() {
        output.isRunnigAnimation
            .sink { [weak self] flag in
                guard let self else { return }
                if flag {
                    self.startAnimation()
                }
            }
            .store(in: &subscriptions)
    }
    
}

extension SplashViewController {
    private func startAnimation() {
        // Step 1: 이동 애니메이션 (오른쪽으로 기울어진 상태로 중앙까지 이동)
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut]) {
            self.logoImageView.center = self.view.center
            self.logoImageView.transform = CGAffineTransform(rotationAngle: .pi / 12) // 약간 오른쪽으로 기울임
        } completion: { _ in
            // Step 2: 스프링 애니메이션 (중앙에서 반동 효과)
            UIView.animate(withDuration: 0.6,
                           delay: 0,
                           usingSpringWithDamping: 0.5, // 반동 강도
                           initialSpringVelocity: 0.8, // 초기 속도
                           options: []) {
                self.logoImageView.transform = .identity // 원래 상태로 복귀 (기울기 해제)
            } completion: { [weak self] _ in
                self?.moveToMainView()
            }
        }
    }
    
    private func getScreenWidth() -> CGFloat {
        // 현재 활성화된 UIWindowScene에서 첫 번째 윈도우를 가져옴
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 0 // 기본값 반환 (예외 처리)
        }
        return window.bounds.width
    }
}

// MARK: - View Transition
extension SplashViewController {
    private func moveToMainView() {
        let fetchChannelListUsecase = DIContainer.shared.resolve(FetchChannelListUsecase.self)
        let createChannelUsecase = DIContainer.shared.resolve(CreateChannelUsecase.self)
        let fetchChannelInfoUsecase = DIContainer.shared.resolve(FetchChannelInfoUsecase.self)
        let factory = DIContainer.shared.resolve(LiveStreamViewControllerFactory.self)
        let viewModel = BroadcastCollectionViewModel(
            fetchChannelListUsecase: fetchChannelListUsecase,
            createChannelUsecase: createChannelUsecase,
            fetchChannelInfoUsecase: fetchChannelInfoUsecase
        )
        let viewController = BroadcastCollectionViewController(viewModel: viewModel, factory: factory)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        /// 유저의 이름이 저장되어 있지 않으면 유저 등록 뷰를 Navigation에 올림
        if UserDefaults.standard.string(forKey: "USER_NAME") == nil {
            let singUpViewModel = SignUpViewModel()
            navigationController.viewControllers.append(SignUpViewController(viewModel: singUpViewModel))
        }
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve) {
            window.rootViewController = navigationController
        }
    }
}
