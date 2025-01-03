import Combine
import UIKit

import BaseFeature
import DesignSystem
import EasyLayout

// MARK: - LiveStreamViewController

public final class LiveStreamViewController: BaseViewController<LiveStreamViewModel> {
    private let chattingList = ChattingListView()
    private let playerView: ShookPlayerView = .init()
    private let infoView: LiveStreamInfoView = .init()
    private let bottomGuideView = UIView()
    private let _title: String
    private let _owner: String
    private let _description: String

    private var shrinkConstraints: [NSLayoutConstraint] = []
    private var expandConstraints: [NSLayoutConstraint] = []
    private var unfoldedConstraint: NSLayoutConstraint?
    private var foldedConstraint: NSLayoutConstraint?
    private var subscription = Set<AnyCancellable>()

    private let viewDidLoadPublisher = PassthroughSubject<Void, Never>()

    private lazy var input = LiveStreamViewModel.Input(
        expandButtonDidTap: playerView.playerControlView.expandButtonDidTap.eraseToAnyPublisher(),
        sliderValueDidChange: playerView.playerControlView.timeControlView.valueDidChanged.eraseToAnyPublisher(),
        playerStateDidChange: playerView.playerStateDidChange.eraseToAnyPublisher(),
        playerGestureDidTap: playerView.playerGestureDidTap.eraseToAnyPublisher(),
        playButtonDidTap: playerView.playerControlView.playButtonDidTap.eraseToAnyPublisher(),
        dismissButtonDidTap: playerView.playerControlView.dismissButtonDidTap.eraseToAnyPublisher(),
        chattingSendButtonDidTap: chattingList.sendButtonDidTap.eraseToAnyPublisher(),
        viewDidLoad: viewDidLoadPublisher.eraseToAnyPublisher()
    )

    private lazy var output = viewModel.transform(input: input)

    public init(title: String, owner: String, description: String, viewModel: LiveStreamViewModel) {
        _title = title
        _owner = owner
        _description = description
        super.init(viewModel: viewModel)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {}

    override public func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadPublisher.send(())
    }

    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        output.isExpanded.value ? .landscapeRight : .portrait
    }

    override public func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        chattingList.isHidden = output.isExpanded.value
        chattingList.endEditing(true)
        infoView.isHidden = output.isExpanded.value
        bottomGuideView.isHidden = output.isExpanded.value
        if output.isExpanded.value {
            NSLayoutConstraint.deactivate(shrinkConstraints)
            NSLayoutConstraint.activate(expandConstraints)
        } else {
            NSLayoutConstraint.activate(shrinkConstraints)
            NSLayoutConstraint.deactivate(expandConstraints)
        }
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playerView.stopPlayback()
    }

    override public func setupViews() {
        view.addSubview(infoView)
        view.addSubview(playerView)
        view.addSubview(chattingList)
        view.addSubview(bottomGuideView)
    }

    override public func setupStyles() {
        view.backgroundColor = .black

        infoView.configureUI(with: (_title, _owner + (_description.isEmpty ? " " : " • ") + _description))
        bottomGuideView.backgroundColor = DesignSystemAsset.Color.darkGray.color
    }

    override public func setupLayouts() {
        playerView.ezl.makeConstraint {
            $0.top(to: view.safeAreaLayoutGuide)
                .horizontal(to: view.safeAreaLayoutGuide)
        }

        shrinkConstraints = [playerView.heightAnchor.constraint(equalTo: playerView.widthAnchor, multiplier: 9.0 / 16.0)]
        NSLayoutConstraint.activate(shrinkConstraints)

        expandConstraints = [
            playerView.topAnchor.constraint(equalTo: view.topAnchor),
            playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        unfoldedConstraint = infoView.topAnchor.constraint(equalTo: playerView.bottomAnchor)
        foldedConstraint = infoView.bottomAnchor.constraint(equalTo: playerView.bottomAnchor)
        foldedConstraint?.isActive = true

        infoView.ezl.makeConstraint {
            $0.horizontal(to: view)
        }

        chattingList.ezl.makeConstraint {
            $0.top(to: infoView.ezl.bottom)
                .horizontal(to: view)
                .bottom(to: view.keyboardLayoutGuide.ezl.top)
        }

        bottomGuideView.ezl.makeConstraint {
            $0.horizontal(to: view)
                .bottom(to: view)
                .top(to: chattingList.ezl.bottom)
        }
    }

    override public func setupActions() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        playerView.addGestureRecognizer(panGesture)
        playerView.isUserInteractionEnabled = true

        playerView.playerGestureDidTap
            .sink { [weak self] _ in
                self?.view.endEditing(true)
            }
            .store(in: &subscription)
    }

    override public func setupBind() {
        output.isExpanded
            .dropFirst()
            .sink { [weak self] flag in
                guard let self else { return }
                changeOrientation()
                playerView.playerControlView.toggleExpandButtonImage(flag)
            }
            .store(in: &subscription)

        output.time
            .sink { [weak self] amount in
                guard let self else { return }
                playerView.seek(to: amount)
            }
            .store(in: &subscription)

        output.isShowedPlayerControl
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] flag in
                guard let self else { return }
                playerView.playerControlViewAlphaAnimalation(flag)
            }
            .store(in: &subscription)

        output.isShowedInfoView
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] flag in
                guard let self else { return }
                infoViewConstraintAnimation(flag)
            }
            .store(in: &subscription)

        output.isPlaying
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] isPlaying in
                guard let self else { return }
                playerView.updataePlayState(isPlaying)
            }
            .store(in: &subscription)

        output.chatList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.chattingList.updateList($0)
            }
            .store(in: &subscription)

        output.dismiss
            .sink { [weak self] _ in
                guard let self else { return }
                dismiss(animated: true)
            }
            .store(in: &subscription)

        output.videoURLString
            .receive(on: DispatchQueue.main)
            .sink { [weak self] urlString in
                guard let self, let url = URL(string: urlString) else { return }
                playerView.fetchVideo(m3u8URL: url)
            }
            .store(in: &subscription)

        output.showAlert
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                showDissmissAlert()
            }
            .store(in: &subscription)
    }
}

extension LiveStreamViewController {
    private func changeOrientation() {
        let orientation: UIInterfaceOrientationMask = output.isExpanded.value ? .landscapeLeft : .portrait

        if #available(iOS 16.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            self.setNeedsUpdateOfSupportedInterfaceOrientations()
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientation))
        } else {
            UIDevice.current.setValue(orientation, forKey: "orientation")
        }
    }

    private func infoViewConstraintAnimation(_ isShowed: Bool) {
        UIView.transition(with: view, duration: 0.3, options: .curveEaseInOut) {
            if isShowed {
                self.foldedConstraint?.isActive = false
                self.unfoldedConstraint?.isActive = true
            } else {
                self.unfoldedConstraint?.isActive = false
                self.foldedConstraint?.isActive = true
            }
            self.view.layoutIfNeeded()
        }
    }

    private func showDissmissAlert() {
        let alert = UIAlertController(title: "방송 알림", message: "이미 종료된 방송입니다.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .destructive) { [weak self] _ in
            guard let self else { return }
            dismiss(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension LiveStreamViewController {
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard !output.isExpanded.value else { return }
        let translation = gesture.translation(in: view)
        let dragScalingFactor: CGFloat = 320
        let minViewScale: CGFloat = 0.75
        let maxDraggingCornerRadius: CGFloat = 48

        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                let scale = max(1 - translation.y / dragScalingFactor, minViewScale)
                view.transform = CGAffineTransform(scaleX: scale, y: scale)
                view.layer.cornerRadius = min(translation.y, maxDraggingCornerRadius)

                if translation.y > 72 {
                    dismiss(animated: true)
                }
            }

        case .cancelled, .ended:
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                self.view.transform = .identity
                self.view.layer.cornerRadius = 0
            }

        default: break
        }
    }
}
