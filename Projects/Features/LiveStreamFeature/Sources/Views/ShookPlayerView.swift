import AVFoundation
import BaseFeature
import Combine
import DesignSystem
import EasyLayoutModule
import UIKit

protocol ShookPlayerViewState {
    var isPlaying: AnyPublisher<Bool, Never> { get }
    var isBuffering: AnyPublisher<Bool, Never> { get }
}

final class ShookPlayerView: BaseView {
    
    private let player: AVPlayer = AVPlayer()
    private let indicatorView: UIActivityIndicatorView =  UIActivityIndicatorView()
    private let playButton: UIButton = UIButton()
    private var playerItem: AVPlayerItem
    private var timeControlView: TimeControlView = TimeControlView()
    private var infoView: LiveStreamInfoView = LiveStreamInfoView()
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
    
    init(with url: URL) {
        playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        super.init(frame: .zero)
        addObserver()
        videoContainerView.backgroundColor = DesignSystemAsset.Color.darkGray.color
        
#warning("Confiure UI 생명 주기 생기면 옮긴다.")
        var playButtonConfig = UIButton.Configuration.plain()
        playButtonConfig.image = DesignSystemAsset.Image.play48.image
        playButton.configuration = playButtonConfig
        playButton.alpha = .zero
        
        timeControlView.alpha = .zero
        
        indicatorView.color = DesignSystemAsset.Color.mainGreen.color
        indicatorView.hidesWhenStopped = true
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
        videoContainerView.addSubview(playButton)
        videoContainerView.addSubview(indicatorView)
        videoContainerView.addSubview(timeControlView)
        
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        
        videoContainerView.ezl.makeConstraint {
            $0.diagonal(to: self)
        }
        
        unfoldedConstraint = infoView.topAnchor.constraint(equalTo: videoContainerView.bottomAnchor)
        foldedConstraint = infoView.bottomAnchor.constraint(equalTo: videoContainerView.bottomAnchor)
        foldedConstraint?.isActive = true
        
        infoView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        infoView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        playButton.ezl.makeConstraint {
            $0.center(to: videoContainerView)
        }
        
        indicatorView.ezl.makeConstraint {
            $0.width(30).height(30).center(to: videoContainerView)
        }
        
        timeControlView.ezl.makeConstraint {
            $0.height(10)
                .horizontal(to: self, padding: 15)
                .bottom(to: videoContainerView, offset: -20)
        }
        
    }
    
    override func setupStyles() {
        playerLayer.frame = videoContainerView.bounds
    }
    
    override func setupActions() {
        
        playButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            if self.playingState {
                self.player.pause()
            } else {
                self.player.play()
            }
        }, for: .touchUpInside)
        
        videoContainerView.addGestureRecognizer(tapGesture)
        
        timeControlView.$currentValue.sink { [weak self] currentValue in
            guard let self else { return }
            self.player.seek(to: CMTime(seconds: Double(currentValue), preferredTimescale: Int32(NSEC_PER_SEC)))
        }
        .store(in: &subscription)
        
        infoView.fillLabels(with: ("영상 제목이 최대 2줄까지 들어갈 예정입니다. 영상 제목이 최대 2줄까지 들어갈 예정입니다.", "닉네임•기타 정보(들어갈 수 있는 거 찾아보기)"))
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
            self.timeControlView.updateSlider(to: Float(floatSecond))
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
            timeControlView.maxValue = Float(CMTimeGetSeconds(playerItem.duration))
            print("\(#function) \(#line) readToplay ")
            
        case.failed, .unknown:
            playingState = false
            print("\(#function) \(#line) failed")
            
        @unknown default:
            fatalError()
        }
    }
    
    func hanldePlayItemBufferString(_ bufferString: String) {
        switch bufferString {
        case "playbackBufferEmpty":
            indicatorView.startAnimating()
            bufferingState = true
            print("\(#function) \(#line) buffering Empty")
            
        case "playbackLikelyToKeepUp", "playbackBufferFull":
            indicatorView.stopAnimating()
            bufferingState = false
            print("\(#function) \(#line) buffering enough")
            
        default:
            return
        }
    }
    
    func handlePlayerTimeControlStatus(_ status: AVPlayer.TimeControlStatus) {
        switch status {
        case .playing:
            playButton.configuration?.image = DesignSystemAsset.Image.pause48.image
            playingState = true
            print("\(#function) \(#line) playing")
            
        case.paused:
            playButton.configuration?.image = DesignSystemAsset.Image.play48.image
            playingState = false
            print("\(#function) \(#line) pause")
            
        case .waitingToPlayAtSpecifiedRate:
            print("\(#function) \(#line) waitingToPlayAtSpecifiedRate")
            
        @unknown default:
            fatalError()
        }
    }
    
    // MARK: - @objc
    @objc func toggleControlPannel() {
        infoViewConstraintAnimation()
        controlPanelAlphaAnimation()
    }
    
}

extension ShookPlayerView {
    func controlPanelAlphaAnimation() {
        UIView.transition(with: videoContainerView, duration: 0.2, options: .transitionCrossDissolve) {
            self.playButton.alpha = self.playButton.alpha == .zero ? 1 : .zero
            self.timeControlView.alpha = self.timeControlView.alpha == .zero ? 1 : .zero
        }
    }
    
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
