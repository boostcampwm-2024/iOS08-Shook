import Combine
import UIKit

import BaseFeature
import BaseFeatureInterface
import DesignSystem

public final class BroadcastUIViewController: BaseViewController<BroadcastCollectionViewModel> {
    private let broadcastStatusStackView = UIStackView()
    private let broadcastStatusImageView = UIImageView()
    private let broadcastStateText = UILabel()
    private let endBroadcastButton = UIButton()
    
    public override func setupViews() {
        broadcastStatusStackView.addArrangedSubview(broadcastStatusImageView)
        broadcastStatusStackView.addArrangedSubview(broadcastStateText)

        view.addSubview(broadcastStatusStackView)
        view.addSubview(endBroadcastButton)
    }
    
    public override func setupStyles() {
        view.backgroundColor = .black
        
        broadcastStatusStackView.axis = .vertical
        broadcastStatusStackView.spacing = 7
        broadcastStatusStackView.alignment = .center
        broadcastStatusImageView.image = DesignSystemAsset.Image.tv48.image
        broadcastStateText.text = "지금은 방송 중"
        broadcastStateText.font = .setFont(.title())
        broadcastStateText.textColor = .white

        endBroadcastButton.setTitle("방송종료", for: .normal)
        endBroadcastButton.layer.cornerRadius = 16
        endBroadcastButton.titleLabel?.font = .setFont(.body1())
        endBroadcastButton.backgroundColor = DesignSystemAsset.Color.mainGreen.color
        endBroadcastButton.setTitleColor(DesignSystemAsset.Color.mainBlack.color, for: .normal)
    }
    
    public override func setupLayouts() {
        broadcastStatusStackView.ezl.makeConstraint {
            $0.horizontal(to: view.safeAreaLayoutGuide)
                .centerY(to: view)
        }
        
        broadcastStatusImageView.ezl.makeConstraint {
            $0.size(with: 117)
                .centerX(to: broadcastStatusStackView)
        }
        
        endBroadcastButton.ezl.makeConstraint {
            $0.height(56)
                .bottom(to: view.safeAreaLayoutGuide, offset: -23)
                .horizontal(to: view, padding: 20)
        }
    }
    
    public override func setupActions() {
        endBroadcastButton.addTarget(self, action: #selector(didTapEndButton), for: .touchUpInside)
    }
    
    @objc
    private func didTapEndButton() {
        let newBroadcastCollectionViewController = BroadcastCollectionViewController(viewModel: viewModel)
        let navigationViewController = UINavigationController(rootViewController: newBroadcastCollectionViewController)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
        
        UIView.transition(with: window, duration: 0, options: .transitionCrossDissolve) {
            window.rootViewController = navigationViewController
        }
    }
}
