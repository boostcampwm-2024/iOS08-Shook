import UIKit

import BaseFeature
import BaseFeatureInterface
import EasyLayoutModule

public final class MockLiveStreamViewModel: ViewModel {
    public struct Input { }
    public struct Output { }
    public init() { }
    public func transform(input: Input) -> Output { return Output() }
}

public final class MockLiveStreamViewController: BaseViewController<MockLiveStreamViewModel> {
    public let playerView = MockShookPlayerView(with: URL(string: "https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8")!)
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        return button
    }()
    
    public override func setupViews() {
        view.addSubview(playerView)
        view.addSubview(dismissButton)
        
        dismissButton.addTarget(self, action: #selector(didTapDismissButton), for: .touchUpInside)
    }
    
    public override func setupLayouts() {
        playerView.ezl.makeConstraint {
            $0.top(to: view.safeAreaLayoutGuide)
                .horizontal(to: view.safeAreaLayoutGuide)
                .height(view.frame.width * 0.5625)
        }
        
        dismissButton.ezl.makeConstraint {
            $0.top(to: view.safeAreaLayoutGuide, offset: 16)
                .trailing(to: view.safeAreaLayoutGuide, offset: -16)
        }
    }
    
    @objc private func didTapDismissButton() {
        dismiss(animated: true, completion: nil)
    }
    
    public override func setupActions() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        playerView.addGestureRecognizer(panGesture)
        playerView.isUserInteractionEnabled = true
    }
}

extension MockLiveStreamViewController {
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                let scale = max(1 - translation.y / 320, 0.75)
                view.transform = CGAffineTransform(scaleX: scale, y: scale)
                view.layer.cornerRadius = min(translation.y, 36)
                
                if translation.y > 56 {
                    dismiss(animated: true)
                }
            }
            
        case .ended, .cancelled:
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                self.view.transform = .identity
                self.view.layer.cornerRadius = 0
            }
            
        default: break
        }
    }
}
