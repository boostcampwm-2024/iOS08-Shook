import UIKit

import Lottie

public final class SHRefreshControl: UIRefreshControl {
    private let animationView = LottieAnimationView(name: "shook", bundle: Bundle(for: DesignSystemResources.self))
    private let maxPullDistance: CGFloat = 150
    
    public override init() {
        super.init(frame: .zero)
        setupView()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateProgress(with offsetY: CGFloat) {
        guard !animationView.isAnimationPlaying else { return }
        let progress = min(abs(offsetY / maxPullDistance), 1)
        animationView.currentProgress = progress
    }
    
    public override func beginRefreshing() {
        super.beginRefreshing()
        animationView.loopMode = .loop
        animationView.play()
    }
    
    public override func endRefreshing() {
        animationView.loopMode = .playOnce
        animationView.play { isFinished in
            if isFinished {
                super.endRefreshing()
                self.animationView.stop()
            }
        }
    }
    
    func setupView() {
        tintColor = .clear
        addSubview(animationView)
        addTarget(self, action: #selector(beginRefreshing), for: .valueChanged)
    }
    
    func setupLayout() {
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 100),
            animationView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
}
