import AVFoundation
import Combine
import UIKit

import BaseFeature
import DesignSystem

public protocol PlayerControlViewAction {
    var playButtonDidTap: AnyPublisher<Void?, Never> { get }
    var expandButtonDidTap: AnyPublisher<Void?, Never> { get }
}

private enum ImageConstants {
    case play
    case pause
    case zoomIn
    case zoomOut
    
    var image: UIImage {
        switch self {
        case .zoomIn:
            return DesignSystemAsset.Image.zoomIn24.image
            
        case .zoomOut:
            return DesignSystemAsset.Image.zoomOut24.image
            
        case .play:
            return DesignSystemAsset.Image.play48.image
            
        case .pause:
            return DesignSystemAsset.Image.pause48.image
        }
    }
}

final class PlayerControlView: BaseView {
    private let playButton: UIButton = UIButton()
    private let expandButton: UIButton = UIButton()
    var timeControlView: TimeControlView = TimeControlView()
    
    @Published private var playButtonTapPublisher: Void?
    @Published private var sliderValuePublisher: Double?
    @Published private var expandButtonTapPublisher: Void?
    
    override func setupViews() {
        self.addSubview(playButton)
        self.addSubview(expandButton)
        self.addSubview(timeControlView)
    }
    
    override func setupLayouts() {
        playButton.ezl.makeConstraint {
            $0.center(to: self)
        }
        
        timeControlView.ezl.makeConstraint {
            $0.height(10)
                .horizontal(to: self, padding: 15)
                .bottom(to: self, offset: -20)
        }
        
        expandButton.ezl.makeConstraint {
            $0.trailing(to: self, offset: -13)
                .top(to: self, offset: 16)
        }
    }
    
    override func setupStyles() {
        self.backgroundColor = .black.withAlphaComponent(0.5)
        
        var playButtonConfig = UIButton.Configuration.plain()
        playButtonConfig.image = ImageConstants.play.image
        playButton.configuration = playButtonConfig
        
        var expandButtonConfig = UIButton.Configuration.plain()
        expandButtonConfig.image = ImageConstants.zoomIn.image
        expandButton.configuration = expandButtonConfig
    }
    
    override func setupActions() {
        playButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.playButtonTapPublisher = ()
        }, for: .touchUpInside)
        
        expandButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.expandButtonTapPublisher = ()
        }, for: .touchUpInside)
    }
}

extension PlayerControlView {
    func toggleExpandButtonImage(_ expanded: Bool) {
        expandButton.configuration?.image = expanded ? ImageConstants.zoomOut.image : ImageConstants.zoomIn.image
    }
    
    func togglePlayerButtonAnimation(_ isPlaying: Bool) {
        playButton.transform = CGAffineTransform(scaleX: .zero, y: .zero)
        
        UIView.animate(withDuration: 0.7,
                       delay: .zero,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.4,
                       options: .allowUserInteraction) {
            if isPlaying {
                self.playButton.configuration?.image = ImageConstants.pause.image
            } else {
                self.playButton.configuration?.image = ImageConstants.play.image
            }
            self.playButton.transform  = .identity
        }
    }
}

extension PlayerControlView: PlayerControlViewAction {
    var expandButtonDidTap: AnyPublisher<Void?, Never> {
        $expandButtonTapPublisher.eraseToAnyPublisher()
    }
    
    var playButtonDidTap: AnyPublisher<Void?, Never> {
        $playButtonTapPublisher.eraseToAnyPublisher()
    }
}
