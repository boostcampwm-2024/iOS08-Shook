import AVFoundation
import Combine
import UIKit

import BaseFeature
import DesignSystem

public protocol PlayerControlViewAction {
    var playButtonDidTap: AnyPublisher<Void, Never> { get }
    var sliderValueDidChange: AnyPublisher<Double, Never> { get }
}

final class PlayerControlView: BaseView {
    private let indicatorView: UIActivityIndicatorView =  UIActivityIndicatorView()
    private let playButton: UIButton = UIButton()
    var timeControlView: TimeControlView = TimeControlView()
    
    @Published private var playButtonTapPublisher: Void = ()
    @Published private var sliderValuePublisher: Double = .zero
    
    override func setupViews() {
        self.addSubview(playButton)
        self.addSubview(indicatorView)
        self.addSubview(timeControlView)
    }
    
    override func setupLayouts() {
        playButton.ezl.makeConstraint {
            $0.center(to: self)
        }
        
        indicatorView.ezl.makeConstraint {
            $0.width(30).height(30).center(to: self)
        }
        
        timeControlView.ezl.makeConstraint {
            $0.height(10)
                .horizontal(to: self, padding: 15)
                .bottom(to: self, offset: -20)
        }
    }
    
    override func setupStyles() {
        self.backgroundColor = .black.withAlphaComponent(0.5)
        
        var playButtonConfig = UIButton.Configuration.plain()
        playButtonConfig.image = DesignSystemAsset.Image.play48.image
        playButton.configuration = playButtonConfig
        
        indicatorView.color = DesignSystemAsset.Color.mainGreen.color
        indicatorView.hidesWhenStopped = true
    }
    
    override func setupActions() {
        playButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.playButtonTapPublisher = ()
        }, for: .touchUpInside)
        
        timeControlView.value
            .compactMap { Double($0)}
            .assign(to: &$sliderValuePublisher)
    }
}

extension PlayerControlView {
    public func toggleIndicator(_ isLoading: Bool) {
        if isLoading {
            indicatorView.startAnimating()
        } else {
            indicatorView.stopAnimating()
        }
    }
    
    public func togglePlayerButtonAnimation(_ status: AVPlayer.TimeControlStatus) {
        playButton.transform = CGAffineTransform(scaleX: .zero, y: .zero)
        
        UIView.animate(withDuration: 0.7,
                       delay: .zero,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.4,
                       options: .allowUserInteraction) {
            if status == .playing {
                self.playButton.configuration?.image = DesignSystemAsset.Image.pause48.image
            } else {
                self.playButton.configuration?.image = DesignSystemAsset.Image.play48.image
            }
            self.playButton.transform  = .identity
        }
    }
}

extension PlayerControlView: PlayerControlViewAction {
    var playButtonDidTap: AnyPublisher<Void, Never> {
        $playButtonTapPublisher.eraseToAnyPublisher()
    }
    
    var sliderValueDidChange: AnyPublisher<Double, Never> {
        $sliderValuePublisher.eraseToAnyPublisher()
    }
}
