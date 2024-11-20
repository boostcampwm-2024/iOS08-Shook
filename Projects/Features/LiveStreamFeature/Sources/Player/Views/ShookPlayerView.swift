import AVFoundation
import Combine
import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

#warning("추후 네트워크 에러 헨들링")

protocol ShookPlayerViewState {
    var isPlaying: AnyPublisher<Bool, Never> { get }
    var isBuffering: AnyPublisher<Bool, Never> { get }
}

private enum Constants: CGFloat {
    case indicatorSize  = 50
}

final class ShookPlayerView: BaseView {
    private let player: AVPlayer = AVPlayer()
    private var playerItem: AVPlayerItem
    private let infoView: LiveStreamInfoView = LiveStreamInfoView()
    private let indicatorView: UIActivityIndicatorView =  UIActivityIndicatorView()
    private var timeObserverToken: Any?
    private var subscription: Set<AnyCancellable> = .init()
    private var unfoldedConstraint: NSLayoutConstraint?
    private var foldedConstraint: NSLayoutConstraint?
    private var isFolded = true
    private var isInitialized = false
    
    // MARK: - lazy var
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
    private lazy var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleControlPannel))
    
    // MARK: - @Published
    @Published private var playingState: Bool = false
    @Published private var bufferingState: Bool = false
    
    public let playerControlView: PlayerControlView = PlayerControlView()
    
    init(with url: URL) {
        playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        super.init(frame: .zero)
        addObserver()
        videoContainerView.backgroundColor = DesignSystemAsset.Color.darkGray.color
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeObserver()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if let playerItem = object as? AVPlayerItem {
            handlePlayItemStatus(playerItem.status)
            hanldePlayItemBufferString(keyPath)
        } else if let player = object as? AVPlayer {
            handlePlayerTimeControlStatus(player.timeControlStatus)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        self.addSubview(infoView)
        self.addSubview(videoContainerView)
        videoContainerView.addSubview(playerControlView)
        videoContainerView.addSubview(indicatorView)
        
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        videoContainerView.ezl.makeConstraint {
            $0.diagonal(to: self)
        }
        
        indicatorView.ezl.makeConstraint {
            $0.width(Constants.indicatorSize.rawValue).height(Constants.indicatorSize.rawValue).center(to: self)
        }
        
        unfoldedConstraint = infoView.topAnchor.constraint(equalTo: videoContainerView.bottomAnchor)
        foldedConstraint = infoView.bottomAnchor.constraint(equalTo: videoContainerView.bottomAnchor)
        foldedConstraint?.isActive = true
        
        infoView.ezl.makeConstraint {
            $0.horizontal(to: self)
        }
        
        playerControlView.ezl.makeConstraint {
            $0.diagonal(to: self)
        }
    }
    
    override func setupStyles() {
        self.playerControlView.alpha = .zero
        
        indicatorView.color = DesignSystemAsset.Color.mainGreen.color
        indicatorView.hidesWhenStopped = true
    }
    
    override func setupActions() {
        videoContainerView.addGestureRecognizer(tapGesture)
        infoView.configureUI(with: ("영상 제목이 최대 2줄까지 들어갈 예정입니다. 영상 제목이 최대 2줄까지 들어갈 예정입니다.", "닉네임•기타 정보(들어갈 수 있는 거 찾아보기)"))
        
        playerControlView.playButtonDidTap.sink { [weak self] in
            guard let self else { return }
            
            if self.playingState {
                self.player.pause()
            } else {
                self.player.play()
            }
        }
        .store(in: &subscription)
        
        playerControlView.sliderValueDidChange.sink { [weak self] newValue in
            guard let self else { return }
            self.player.seek(to: CMTime(seconds: newValue, preferredTimescale: Int32(NSEC_PER_SEC)))
        }
        .store(in: &subscription)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = videoContainerView.bounds
    }
}

extension ShookPlayerView {
    enum BufferState: String {
        case playbackBufferEmpty
        case playbackLikelyToKeepUp
        case playbackBufferFull
    }
    
    // MARK: - register / remove observer
    private func addObserver() {
        addObserverPlayerItem()
        addObserverPlayer()
    }
    
    private func addObserverPlayerItem() {
        playerItem.addObserver(self,
                               forKeyPath: #keyPath(AVPlayerItem.status),
                               options: [.old, .new],
                               context: nil) // 동일한 객체를 여러 키 경로에서 관찰할 때 구분하기 위한 식별자
        
        playerItem.addObserver(self, forKeyPath: BufferState.playbackBufferEmpty.rawValue, options: .new, context: nil)
        playerItem.addObserver(self, forKeyPath: BufferState.playbackLikelyToKeepUp.rawValue, options: .new, context: nil)
        playerItem.addObserver(self, forKeyPath: BufferState.playbackBufferFull.rawValue, options: .new, context: nil)
    }
    
    private func addObserverPlayer() {
        player.addObserver(self, forKeyPath: "timeControlStatus", context: nil)
        
        let interval = CMTimeMakeWithSeconds(1, preferredTimescale: Int32(NSEC_PER_SEC))
        
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] cmtTime in
            guard let self else { return }
            let floatSecond = CMTimeGetSeconds(cmtTime)
            playerControlView.timeControlView.updateSlider(to: Float(floatSecond))
        }
    }
    
    private func removeObserver() {
        self.removeObserver(self, forKeyPath: #keyPath(AVPlayer.timeControlStatus))
        self.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        self.removeObserver(self, forKeyPath: BufferState.playbackBufferEmpty.rawValue)
        self.removeObserver(self, forKeyPath: BufferState.playbackLikelyToKeepUp.rawValue)
        self.removeObserver(self, forKeyPath: BufferState.playbackBufferFull.rawValue)
        
        if let token = timeObserverToken {
            player.removeTimeObserver(token)
        }
    }
    
    // MARK: - observeValue Handler
    func handlePlayItemStatus(_ status: AVPlayerItem.Status) {
        switch status {
        case .readyToPlay: // 성공
            if !isInitialized {
                player.play()
                isInitialized = true
            }
            playerControlView.timeControlView.maxValue = Float(CMTimeGetSeconds(playerItem.duration))
            
        case.failed, .unknown:
            playingState = false
            
        @unknown default:
            break
        }
    }
    
    func hanldePlayItemBufferString(_ bufferString: String) {
        switch bufferString {
        case "playbackBufferEmpty":
            bufferingState = true
            indicatorView.startAnimating()
            
        case "playbackLikelyToKeepUp", "playbackBufferFull":
            bufferingState = false
            indicatorView.stopAnimating()
            
        default:
            return
        }
    }
    
    func handlePlayerTimeControlStatus(_ status: AVPlayer.TimeControlStatus) {
        playerControlView.togglePlayerButtonAnimation(status)
        switch status {
        case .playing:
            playingState = true
            
        case.paused:
            playingState = false
            
        case .waitingToPlayAtSpecifiedRate:
            break
            
        @unknown default:
            break
        }
    }
    
    // MARK: - @objc
    @objc func toggleControlPannel() {
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve) {
            self.playerControlView.alpha = self.playerControlView.alpha == .zero ? 1 : .zero
        }
        infoViewConstraintAnimation()
    }
}

extension ShookPlayerView {
    // - MARK: animation
    func infoViewConstraintAnimation() {
        UIView.transition(with: self, duration: 0.3, options: .curveEaseInOut) {
            if self.isFolded {
                self.unfoldedConstraint?.isActive = true
                self.foldedConstraint?.isActive = false
            } else {
                self.unfoldedConstraint?.isActive = false
                self.foldedConstraint?.isActive = true
                
            }
            self.isFolded = !self.isFolded
            self.layoutIfNeeded()
        }
    }
}

extension ShookPlayerView: ShookPlayerViewState {
    var isPlaying: AnyPublisher<Bool, Never> {
        $playingState.eraseToAnyPublisher()
    }
    
    var isBuffering: AnyPublisher<Bool, Never> {
        $bufferingState.eraseToAnyPublisher()
    }
}
