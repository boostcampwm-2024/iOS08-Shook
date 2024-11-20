import Combine
import UIKit

import BaseFeature
import BaseFeatureInterface
import DesignSystem

public final class BroadcastUIViewController: BaseViewController<BroadcastCollectionViewModel> {
    private let stackView = UIStackView()
    private let imageView = UIImageView()
    private let broadcastStateText = UILabel()
    private let willEndButton = UIButton()
    private let input = BroadcastCollectionViewModel.Input()
    
    public override func setupBind() {
        viewModel.transform(input: input)
    }
    
    public override func setupViews() {
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(broadcastStateText)

        view.addSubview(stackView)
        view.addSubview(willEndButton)
    }
    
    public override func setupStyles() {
        stackView.axis = .vertical
        stackView.spacing = 7
        stackView.alignment = .center
        imageView.image = DesignSystemAsset.Image.tv48.image
        
        broadcastStateText.text = "지금은 방송 중"
        willEndButton.setTitle("방송종료", for: .normal)
        willEndButton.layer.cornerRadius = 16
        
        // Fonts
        broadcastStateText.font = .setFont(.title(weight: .bold))
        willEndButton.titleLabel?.font = .setFont(.body1(weight: .semiBold))
        
        // Colors
        broadcastStateText.textColor = .white
        willEndButton.backgroundColor = DesignSystemAsset.Color.mainGreen.color
        willEndButton.setTitleColor( DesignSystemAsset.Color.mainBlack.color, for: .normal)
        view.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
    }
    
    public override func setupLayouts() {
        stackView.ezl.makeConstraint {
            $0.horizontal(to: view.safeAreaLayoutGuide)
                .centerY(to: view)
        }
        
        imageView.ezl.makeConstraint {
            $0.size(with: 117)
                .centerX(to: stackView)
        }
        
        willEndButton.ezl.makeConstraint {
            $0.height(56)
                .bottom(to: view.safeAreaLayoutGuide, offset: -23)
                .horizontal(to: view, padding: 20)
        }
    }
    
    public override func setupActions() {
        willEndButton.addTarget(self, action: #selector(didTapEndButton), for: .touchUpInside)
    }
    
    @objc
    private func didTapEndButton() {
        let broadcastCollectionViewController = BroadcastCollectionViewController(viewModel: viewModel)
        let navigationViewController = UINavigationController(rootViewController: broadcastCollectionViewController)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
        
        UIView.transition(with: window, duration: 0, options: .transitionCrossDissolve) {
            window.rootViewController = navigationViewController
        }
    }
}
