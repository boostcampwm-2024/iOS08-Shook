import AVFoundation
import UIKit

import BaseFeature
import BaseFeatureInterface
import EasyLayoutModule

public final class SampleLiveStreamViewModel: ViewModel {
    public struct Input { }
    public struct Output { }
    public init() { }
    public func transform(input: Input) -> Output { return Output() }
}

public final class SampleLiveStreamViewController: BaseViewController<SampleLiveStreamViewModel> {
    public let playerView = SampleShookPlayerView(with: URL(string: "https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8")!)
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
    
    public override func setupStyles() {
        view.backgroundColor = .black
    }
    
    @objc private func didTapDismissButton() {
        dismiss(animated: true, completion: nil)
    }
    
    public override func setupActions() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        playerView.addGestureRecognizer(panGesture)
        playerView.isUserInteractionEnabled = true // 제스처 인식을 위해 필수
    }
}

public final class SampleShookPlayerView: BaseView {
    private let player: AVPlayer = AVPlayer()
    private var playerItem: AVPlayerItem
    
    private lazy var playerLayer: AVPlayerLayer = {
        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspectFill
        return layer
    }()
    private lazy var videoContainerView: UIView = {
        let view = UIView()
        view.layer.addSublayer(playerLayer)
        return view
    }()
    
    init(with url: URL) {
        playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        super.init(frame: .zero)
        videoContainerView.backgroundColor = .darkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        super.setupViews()
        self.backgroundColor = .systemBackground
        self.addSubview(videoContainerView)
    }
    
    public override func setupLayouts() {
        super.setupLayouts()
        
        videoContainerView.ezl.makeConstraint {
            $0.diagonal(to: self)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = videoContainerView.bounds
    }
}

extension SampleLiveStreamViewController {
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                let scale = max(1 - translation.y / 320, 0.8)
                view.transform = CGAffineTransform(scaleX: scale, y: scale)
                view.layer.cornerRadius = min(translation.y, 24)
            }
            
        case .ended, .cancelled:
            if translation.y > 20 {
                dismiss(animated: true)
            } else {
                view.transform = .identity
            }
            
        default: break
        }
    }
}
