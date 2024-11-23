import AVFoundation
import UIKit

import BaseFeature
import EasyLayoutModule

public final class MockShookPlayerView: BaseView {
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
