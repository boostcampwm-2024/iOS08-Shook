import Combine
import UIKit

import BaseFeature
import DesignSystem
import EasyLayout

// MARK: - TimeControlState

private protocol TimeControlState {
    func updateSlider(to time: Float)
}

// MARK: - TimeControlAction

private protocol TimeControlAction {
    var valueDidChanged: AnyPublisher<Float?, Never> { get }
}

// MARK: - TimeControlView

final class TimeControlView: BaseView {
    private let liveStringLabel: UILabel = .init()
    private let slider: UISlider = .init()

    var maxValue: Float = 0 {
        willSet {
            slider.maximumValue = newValue
        }
    }

    @Published private var currentValue: Float?

    override func setupViews() {
        addSubview(liveStringLabel)
        addSubview(slider)
    }

    override func setupLayouts() {
        liveStringLabel.ezl.makeConstraint {
            $0.leading(to: self)
                .centerY(to: slider)
        }

        slider.ezl.makeConstraint {
            $0.leading(to: liveStringLabel.ezl.trailing, offset: 5)
                .trailing(to: self)
                .vertical(to: self)
        }
    }

    override func setupStyles() {
        liveStringLabel.textColor = DesignSystemAsset.Color.white.color
        liveStringLabel.font = .setFont(.caption2())
        liveStringLabel.text = "live"

        slider.setThumbImage(renderThumbImage(size: CGSize(width: 10, height: 10)), for: .normal)
        slider.minimumTrackTintColor = DesignSystemAsset.Color.mainGreen.color
        slider.maximumTrackTintColor = DesignSystemAsset.Color.gray.color
    }

    override func setupActions() {
        slider.addTarget(self, action: #selector(changedValue), for: .valueChanged)
    }
}

extension TimeControlView {
    private func renderThumbImage(size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            let rect = CGRect(origin: .zero, size: size)
            let path = UIBezierPath(ovalIn: rect) // 원형 경로 생성
            DesignSystemAsset.Color.mainGreen.color.setFill()
            path.fill()
        }
    }

    @objc private func changedValue() {
        currentValue = slider.value
    }
}

// MARK: TimeControlState

extension TimeControlView: TimeControlState {
    func updateSlider(to time: Float) {
        slider.setValue(time, animated: false)
    }
}

// MARK: TimeControlAction

extension TimeControlView: TimeControlAction {
    var valueDidChanged: AnyPublisher<Float?, Never> {
        $currentValue.eraseToAnyPublisher()
    }
}
