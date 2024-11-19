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
    private var timeObserverToken: Any?
    private var subscription: Set<AnyCancellable> = .init()
    
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
    @Published private var isPlayingState: Bool = false
    @Published private var isBufferingState: Bool = false
    
    init(with url: URL) {
        playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        super.init(frame: .zero)
        addObserver()
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
            
            switch playerItem.status {
            case .readyToPlay: // 성공
                player.play()
                timeControlView.maxValue = Float(CMTimeGetSeconds(playerItem.duration))
                print("\(#function) \(#line) readToplay")
                
            case.failed, .unknown:
                isPlayingState = false
                print("\(#function) \(#line) failed")
                
            @unknown default:
                fatalError()
            }
            
            switch keyPath {
            case "playbackBufferEmpty":
                indicatorView.startAnimating()
                isBufferingState = true
                print("\(#function) \(#line) buffering Empty")
                
            case "playbackLikelyToKeepUp", "playbackBufferFull":
                indicatorView.stopAnimating()
                isBufferingState = false
                print("\(#function) \(#line) buffering enough")
                
            default:
                return
            }
            
        } else if let player = object as? AVPlayer {
            switch player.timeControlStatus {
            case .playing:
                playButton.configuration?.image = DesignSystemAsset.Image.pause48.image
                isPlayingState = true
                print("\(#function) \(#line) playing")
                
            case.paused:
                playButton.configuration?.image = DesignSystemAsset.Image.play48.image
                isPlayingState = false
                print("\(#function) \(#line) pause")
                
            case .waitingToPlayAtSpecifiedRate:
                print("\(#function) \(#line) waitingToPlayAtSpecifiedRate")
                
            @unknown default:
                fatalError()
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
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
        
        var playButtonConfig = UIButton.Configuration.plain()
        playButtonConfig.image = DesignSystemAsset.Image.play48.image
        playButton.configuration = playButtonConfig
        playButton.isHidden = true
        
        timeControlView.isHidden = true
        
        indicatorView.color = DesignSystemAsset.Color.mainGreen.color
        indicatorView.hidesWhenStopped = true
    }
    
    override func setupActions() {
        
        playButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            if self.isPlayingState {
                self.player.pause()
            } else {
                self.player.play()
            }
        }, for: .touchUpInside)
        
        videoContainerView.addGestureRecognizer(tapGesture)
        
        timeControlView.$currentValue.sink { [weak self] currentValue in
            guard let self else { return }
            self.player.seek(to: CMTime(seconds: Double(currentValue), preferredTimescale: Int32(NSEC_PER_SEC))) { _ in
                print("completion")
            }
        }
        .store(in: &subscription)
    }
    
}

extension ShookPlayerView {
    
    enum BufferState: String {
        case playbackBufferEmpty
        case playbackLikelyToKeepUp
        case playbackBufferFull
    }
    
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
    
    @objc func toggleControlPannel() {
        UIView.transition(with: videoContainerView, duration: 0.2, options: .transitionCrossDissolve) {
            self.playButton.isHidden = !self.playButton.isHidden
            self.timeControlView.isHidden = !self.timeControlView.isHidden
        }
        
    }
    
}

extension ShookPlayerView: ShookPlayerViewState {
    var isPlaying: AnyPublisher<Bool, Never> {
        $isPlayingState.eraseToAnyPublisher()
    }
    
    var isBuffering: AnyPublisher<Bool, Never> {
        $isBufferingState.eraseToAnyPublisher()
    }
    
}
