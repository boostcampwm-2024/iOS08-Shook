import AVFoundation
import Combine
import UIKit

import BaseFeature
import DesignSystem

// MARK: - PlayerControlViewAction

public protocol PlayerControlViewAction {
    var playButtonDidTap: AnyPublisher<Void?, Never> { get }
    var expandButtonDidTap: AnyPublisher<Void?, Never> { get }
    var dismissButtonDidTap: AnyPublisher<Void?, Never> { get }
}

// MARK: - ImageConstants

private enum ImageConstants {
    case play
    case pause
    case zoomIn
    case zoomOut
    case dismiss

    var image: UIImage {
        switch self {
        case .zoomIn:
            DesignSystemAsset.Image.zoomIn24.image

        case .zoomOut:
            DesignSystemAsset.Image.zoomOut24.image

        case .play:
            DesignSystemAsset.Image.play48.image

        case .pause:
            DesignSystemAsset.Image.pause48.image

        case .dismiss:
            DesignSystemAsset.Image.chevronDown24.image
        }
    }
}

// MARK: - PlayerControlView

final class PlayerControlView: BaseView {
    private let playButton: UIButton = .init()
    private let expandButton: UIButton = .init()
    private let dismissButton: UIButton = .init()
    var timeControlView: TimeControlView = .init()

    @Published private var playButtonTapPublisher: Void?
    @Published private var sliderValuePublisher: Double?
    @Published private var expandButtonTapPublisher: Void?
    @Published private var dismissButtonTapPublisher: Void?

    override func setupViews() {
        addSubview(playButton)
        addSubview(expandButton)
        addSubview(timeControlView)
        addSubview(dismissButton)
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

        dismissButton.ezl.makeConstraint {
            $0.leading(to: self, offset: 13)
                .top(to: self, offset: 16)
        }
    }

    override func setupStyles() {
        backgroundColor = .black.withAlphaComponent(0.5)

        var playButtonConfig = UIButton.Configuration.plain()
        playButtonConfig.image = ImageConstants.play.image
        playButton.configuration = playButtonConfig

        var expandButtonConfig = UIButton.Configuration.plain()
        expandButtonConfig.image = ImageConstants.zoomIn.image
        expandButton.configuration = expandButtonConfig

        var dismissButtonConfig = UIButton.Configuration.plain()
        dismissButtonConfig.image = ImageConstants.dismiss.image
        dismissButton.configuration = dismissButtonConfig
    }

    override func setupActions() {
        playButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            playButtonTapPublisher = ()
        }, for: .touchUpInside)

        expandButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            expandButtonTapPublisher = ()
        }, for: .touchUpInside)

        dismissButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            dismissButtonTapPublisher = ()
        }, for: .touchUpInside)
    }
}

extension PlayerControlView {
    func toggleExpandButtonImage(_ expanded: Bool) {
        expandButton.configuration?.image = expanded ? ImageConstants.zoomOut.image : ImageConstants.zoomIn.image
        dismissButton.configuration?.image = expanded ? nil : ImageConstants.dismiss.image
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
            self.playButton.transform = .identity
        }
    }
}

// MARK: PlayerControlViewAction

extension PlayerControlView: PlayerControlViewAction {
    var expandButtonDidTap: AnyPublisher<Void?, Never> {
        $expandButtonTapPublisher.eraseToAnyPublisher()
    }

    var playButtonDidTap: AnyPublisher<Void?, Never> {
        $playButtonTapPublisher.eraseToAnyPublisher()
    }

    var dismissButtonDidTap: AnyPublisher<Void?, Never> {
        $dismissButtonTapPublisher.eraseToAnyPublisher()
    }
}
