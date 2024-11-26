import Combine
import UIKit

import BaseFeature
import BaseFeatureInterface
import DesignSystem
import EasyLayoutModule

public final class SplashViewController: BaseViewController<SplashViewModel> {
    
    private let gradientsColor: [CGColor] = [#colorLiteral(red: 0.08536987752, green: 0.09035866708, blue: 0.1243042126, alpha: 1), #colorLiteral(red: 0.09964027256, green: 0.2065343261, blue: 0.2179464698, alpha: 1)]
    private let gradientLayer = CAGradientLayer()
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
        view.layer.addSublayer(gradientLayer)
        view.addSubview(logoImageView)
        gradientLayer.frame = view.bounds
    }
    
    public override func setupStyles() {
        logoImageView.image = DesignSystemAsset.Image.mainLogo.image
        logoImageView.contentMode = .scaleAspectFit
        gradientLayer.colors = gradientsColor
        
        gradientLayer.type = .axial
        gradientLayer.startPoint = CGPoint(x: 0.8, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.2, y: 1)
    }
    
    public override func setupLayouts() {
        let screenWidth = getScreenWidth()
        let length = screenWidth / 1.5
        logoImageView.frame = CGRect(x: -length + 50, y: view.center.y - (length/2), width: length, height: length) // 화면 왼쪽에서 시작
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
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            self.logoImageView.center = self.view.center
            self.logoImageView.transform = CGAffineTransform(rotationAngle: .pi / 12) // 약간 오른쪽으로 기울임
        }) { _ in
            // Step 2: 스프링 애니메이션 (중앙에서 반동 효과)
            UIView.animate(withDuration: 0.6,
                           delay: 0,
                           usingSpringWithDamping: 0.5, // 반동 강도
                           initialSpringVelocity: 0.8, // 초기 속도
                           options: [],
                           animations: {
                self.logoImageView.transform = .identity // 원래 상태로 복귀 (기울기 해제)
            }) { [weak self] _ in
                #warning("이동 코드")
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
    
    private func move() {
        
    }
    
}
