import Combine
import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

public final class LiveStreamViewController: BaseViewController<LiveStreamViewModel> {
    private var shrinkConstraint: NSLayoutConstraint?
    private var expandConstraint: NSLayoutConstraint?
    private var subscription = Set<AnyCancellable>()
    private lazy var input = LiveStreamViewModel.Input(
        expandButtonDidTap: playerView.playerControlView.expandButtonDidTap.dropFirst().eraseToAnyPublisher(),
        sliderValueDidChange: playerView.playerControlView.timeControlView.valueDidChanged.dropFirst().eraseToAnyPublisher(),
        playerStateDidChange: playerView.playerStateDidChange.eraseToAnyPublisher(),
        playerGestureDidTap: playerView.playerGestureDidTap.dropFirst().eraseToAnyPublisher(),
        playButtonDidTap: playerView.playerControlView.playButtonDidTap.dropFirst().eraseToAnyPublisher(),
        chatingSendButtonDidTap: chatInputField.sendButtonDidTap.eraseToAnyPublisher()
    )
    private lazy var output = viewModel.transform(input: input)
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return output.isExpanded.value ? .landscapeLeft: .portrait
    }
    
    private let chatingList = ChatingListView()
    private let chatInputField = ChatInputField()
    private let playerView: ShookPlayerView = ShookPlayerView(with: URL(string: "https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8")!)
    
    public override func setupViews() {
        view.addSubview(playerView)
        view.addSubview(chatingList)
        view.addSubview(chatInputField)
    }
    
    public override func setupStyles() {
        view.backgroundColor = .black
    }
    
    public override func setupLayouts() {
        playerView.ezl.makeConstraint {
            $0.top(to: view.safeAreaLayoutGuide)
                .horizontal(to: view.safeAreaLayoutGuide)
        }
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let width = windowScene.screen.bounds.width
    
        shrinkConstraint = playerView.heightAnchor.constraint(equalToConstant: 200)
        shrinkConstraint?.isActive = true
        expandConstraint = playerView.heightAnchor.constraint(equalToConstant: width)
        
        chatingList.ezl.makeConstraint {
            $0.top(to: playerView.ezl.bottom)
                .horizontal(to: view)
                .bottom(to: chatInputField.ezl.top)
        }
        
        chatInputField.ezl.makeConstraint {
            $0.horizontal(to: view)
                .bottom(to: view.keyboardLayoutGuide.ezl.top)
        }
    }
        
    public override func setupActions() {
        
    }
    
    public override func setupBind() {
        output.isExpanded.sink { [weak self]  flag in
            guard let self else { return }
            self.changeOrientation()
            self.playerView.playerControlView.toggleExpandButtonImage(flag)
        }
        .store(in: &subscription)
        
        output.time.sink { [weak self] amount in
            guard let self else { return }
            self.playerView.seek(to: amount)
        }
        .store(in: &subscription)
        
        output.isplayerControlShowed.sink { [weak self] flag in
            guard let self else { return }
            self.playerView.updatePlayerAnimation(flag)
        }
        .store(in: &subscription)
        
        output.isPlaying
            .removeDuplicates()
            .sink { [weak self] isPlaying in
                guard let self else { return }
                self.playerView.updataePlayState(isPlaying)
            }
            .store(in: &subscription)
        
        output.chatList
            .sink { [weak self] in
                self?.chatingList.updateList($0)
            }
            .store(in: &subscription)
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if output.isExpanded.value {
            shrinkConstraint?.isActive = false
            expandConstraint?.isActive = true
        } else {
            shrinkConstraint?.isActive = false
            shrinkConstraint?.isActive = true
        }
        
    }
}

extension LiveStreamViewController {
    func changeOrientation() {
        let appDelegate = UIApplication.shared.delegate
        let orientation: UIInterfaceOrientationMask = output.isExpanded.value ? .landscapeLeft: .portrait

        if #available(iOS 16.0, *) {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                self.setNeedsUpdateOfSupportedInterfaceOrientations()
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientation))
        } else {
            UIDevice.current.setValue(orientation, forKey: "orientation")
        }
    }
}
