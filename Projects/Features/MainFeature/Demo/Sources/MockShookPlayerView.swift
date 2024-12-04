import AVFoundation
import UIKit

import BaseFeature
import EasyLayout

public final class MockShookPlayerView: BaseView {
    private let player: AVPlayer = .init()
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

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setupViews() {
        super.setupViews()
        backgroundColor = .systemBackground
        addSubview(videoContainerView)
    }

    override public func setupLayouts() {
        super.setupLayouts()

        videoContainerView.ezl.makeConstraint {
            $0.diagonal(to: self)
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = videoContainerView.bounds
    }
}
