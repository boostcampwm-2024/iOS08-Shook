import AVFoundation
import Combine
import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

protocol ShhokPlayerViewState {
    func updataePlayState(_ isPlaying: Bool)
}

protocol ShookPlayerViewAciton {
    var playerStateDidChange: AnyPublisher<Bool?, Never> { get }
    var playerGestureDidTap: AnyPublisher<Void?, Never> { get }
}

private enum Constants: CGFloat {
    case indicatorSize  = 50
}

private enum BufferStateConstants: String {
    case playbackBufferEmpty
    case playbackLikelyToKeepUp
    case playbackBufferFull
}

final class ShookPlayerView: BaseView {
    private let player: AVPlayer = AVPlayer()
    private var playerItem: AVPlayerItem?
    
    private let indicatorView: UIActivityIndicatorView =  UIActivityIndicatorView()
    private var timeObserverToken: Any?
    private var subscription: Set<AnyCancellable> = .init()
    private var isInitialized = false
    private var isURLSet = false
    
    // MARK: - @Published
    @Published private var playingStateChangedPublisher: Bool?
    @Published private var playerGestureTapPublisher: Void?
    
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
    
    public let playerControlView: PlayerControlView = PlayerControlView()
    
    override init() {
        super.init(frame: .zero)
        addObserver()
    }
    
    func stopPlayback() {
        player.pause()
        player.replaceCurrentItem(with: nil)
    }
    
    func fetchVideo(m3u8URL: URL) {
        playerItem = AVPlayerItem(url: m3u8URL)
        player.replaceCurrentItem(with: playerItem)
        player.play()
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
        
        playerControlView.ezl.makeConstraint {
            $0.diagonal(to: self)
        }
    }
    
    override func setupStyles() {
        playerControlView.alpha = .zero
        
        videoContainerView.backgroundColor = .black
        
        indicatorView.color = DesignSystemAsset.Color.mainGreen.color
        indicatorView.hidesWhenStopped = true
    }
    
    override func setupActions() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleControlPannel))
        videoContainerView.addGestureRecognizer(tapGesture)
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = videoContainerView.bounds
    }
}

extension ShookPlayerView {
    // MARK: - register / remove observer
    private func addObserver() {
        addObserverPlayerItem()
        addObserverPlayer()
    }
    
    private func addObserverPlayerItem() {
        playerItem?.addObserver(self,
                               forKeyPath: #keyPath(AVPlayerItem.status),
                               options: [.old, .new],
                               context: nil) // 동일한 객체를 여러 키 경로에서 관찰할 때 구분하기 위한 식별자
        
        playerItem?.addObserver(self, forKeyPath: BufferStateConstants.playbackBufferEmpty.rawValue, options: .new, context: nil)
        playerItem?.addObserver(self, forKeyPath: BufferStateConstants.playbackLikelyToKeepUp.rawValue, options: .new, context: nil)
        playerItem?.addObserver(self, forKeyPath: BufferStateConstants.playbackBufferFull.rawValue, options: .new, context: nil)
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
        if let token = timeObserverToken {
            player.removeTimeObserver(token)
            timeObserverToken = nil
        }
        
        player.removeObserver(self, forKeyPath: "timeControlStatus")
        
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        playerItem?.removeObserver(self, forKeyPath: BufferStateConstants.playbackBufferEmpty.rawValue)
        playerItem?.removeObserver(self, forKeyPath: BufferStateConstants.playbackLikelyToKeepUp.rawValue)
        playerItem?.removeObserver(self, forKeyPath: BufferStateConstants.playbackBufferFull.rawValue)
    }
    
    // MARK: - observeValue Handler
    private func handlePlayItemStatus(_ status: AVPlayerItem.Status) {
        switch status {
        case .readyToPlay: // 성공
            guard let playerItem else { return }
            playerControlView.timeControlView.maxValue = Float(CMTimeGetSeconds(playerItem.duration))
            
        case.failed, .unknown:
        #warning("에러")
            break
            
        @unknown default:
            break
        }
    }
    
    private func hanldePlayItemBufferString(_ bufferString: String) {
        switch bufferString {
        case "playbackBufferEmpty":
            indicatorView.startAnimating()
            
        case "playbackLikelyToKeepUp", "playbackBufferFull":
            indicatorView.stopAnimating()
            
        default:
            return
        }
    }
    
    private func handlePlayerTimeControlStatus(_ status: AVPlayer.TimeControlStatus) {
        switch status {
        case .playing:
            playingStateChangedPublisher = true
            
        case.paused:
            playingStateChangedPublisher = false
            
        case .waitingToPlayAtSpecifiedRate:
            break
            
        @unknown default:
            break
        }
    }
    
    // MARK: - @objc
    @objc func toggleControlPannel() {
        playerGestureTapPublisher = ()
    }
}

extension ShookPlayerView {
    func seek(to newValue: Double) {
        self.player.seek(to: CMTime(seconds: newValue, preferredTimescale: Int32(NSEC_PER_SEC)))
    }
    
    // - MARK: animation
    func playerControlViewAlphaAnimalation(_ isShowed: Bool) {
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve) {
            if isShowed {
                self.playerControlView.alpha = 1
            } else {
                self.playerControlView.alpha = .zero
            }
        }
    }
}

extension ShookPlayerView: ShhokPlayerViewState {
    func updataePlayState(_ isPlaying: Bool) {
        if isPlaying {
            player.play()
        } else {
            player.pause()
        }
        playerControlView.togglePlayerButtonAnimation(isPlaying)
    }
}

extension ShookPlayerView: ShookPlayerViewAciton {
    var playerStateDidChange: AnyPublisher<Bool?, Never> {
        $playingStateChangedPublisher.eraseToAnyPublisher()
    }
    
    var playerGestureDidTap: AnyPublisher<Void?, Never> {
        $playerGestureTapPublisher.eraseToAnyPublisher()
    }
}
