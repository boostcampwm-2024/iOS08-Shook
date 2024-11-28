import UIKit

import Lottie

public final class SHLoadingView: UIView {
    private let message: String
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "loading", bundle: Bundle(for: DesignSystemResources.self))
        animation.loopMode = .loop
        animation.translatesAutoresizingMaskIntoConstraints = false
        return animation
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public init(message: String) {
        self.message = message
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        setupStyles()
        animationView.play()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(blurEffectView)
        addSubview(animationView)
        addSubview(messageLabel)
        
        messageLabel.text = message
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            blurEffectView.centerXAnchor.constraint(equalTo: centerXAnchor),
            blurEffectView.centerYAnchor.constraint(equalTo: centerYAnchor),
            blurEffectView.widthAnchor.constraint(equalToConstant: 200),
            blurEffectView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -24),
            animationView.widthAnchor.constraint(equalToConstant: 300),
            animationView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 56)
        ])
    }
    
    private func setupStyles() {
        blurEffectView.layer.cornerRadius = 24
        blurEffectView.clipsToBounds = true
    }
}
