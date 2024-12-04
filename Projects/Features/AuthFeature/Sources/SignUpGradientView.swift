import UIKit

final class SignUpGradientView: UIView {
    private let gradientLayer = CAGradientLayer()

    private let colors: [[CGColor]] = [
        [CGColor(red: 31 / 255, green: 52 / 255, blue: 55 / 255, alpha: 1),
         CGColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1)],

        [CGColor(red: 31 / 255, green: 52 / 255, blue: 55 / 255, alpha: 1),
         CGColor(red: 22 / 255, green: 23 / 255, blue: 31 / 255, alpha: 1)],

        [CGColor(red: 22 / 255, green: 23 / 255, blue: 31 / 255, alpha: 1),
         CGColor(red: 31 / 255, green: 52 / 255, blue: 55 / 255, alpha: 1)],

        [CGColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1),
         CGColor(red: 31 / 255, green: 52 / 255, blue: 55 / 255, alpha: 1)],
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
        startDynamicColorAnimation()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradientLayer()
        startDynamicColorAnimation()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private func setupGradientLayer() {
        gradientLayer.colors = colors.first
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        layer.insertSublayer(gradientLayer, at: 0)
    }

    private func startDynamicColorAnimation() {
        let colorAnimation = CAKeyframeAnimation(keyPath: "colors")
        colorAnimation.values = colors
        colorAnimation.keyTimes = [0.0, 0.33, 0.66, 1.0]
        colorAnimation.duration = 4.0
        colorAnimation.autoreverses = true
        colorAnimation.repeatCount = .infinity
        gradientLayer.add(colorAnimation, forKey: "dynamicColorChange")
    }
}
