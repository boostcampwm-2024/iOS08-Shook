import AVFoundation
import BaseFeature
import EasyLayoutModule
import UIKit

final class ShookPlayerView: BaseView {
    
    private let player: AVPlayer = AVPlayer()
    
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
    
    override func setupViews() {
        super.setupViews()
        self.addSubview(videoContainerView)
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        
        videoContainerView.ezl.makeConstraint {
            $0.diagonal(to: self)
        }
        
        setVideo()
    }
    
    override func setupStyles() {
        playerLayer.frame = videoContainerView.bounds
    }
    
}

extension ShookPlayerView {
    
    private func setVideo() {
        guard let url = URL(string: "https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8") else { return }
        
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        
        player.play()
    }
}
