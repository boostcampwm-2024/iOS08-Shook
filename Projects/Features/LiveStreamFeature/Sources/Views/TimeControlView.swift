import BaseFeature
import Combine
import DesignSystem
import EasyLayoutModule
import UIKit

protocol TimeControlAction {
    var value: AnyPublisher<Float, Never> { get }
}

final class TimeControlView: BaseView {
    public var maxValue: Float = 0 {
        willSet {
            slider.maximumValue = newValue
        }
    }
    
    @Published var currentValue: Float = 0
    
    private let liveStringLabel: UILabel = UILabel()
    private let slider: UISlider = UISlider()
    
    override func setupViews() {
        self.addSubview(liveStringLabel)
        self.addSubview(slider)
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
#warning("나중에 색 바꾸기")
    override func setupStyles() {
        liveStringLabel.textColor = DesignSystemAsset.Color.white.color
        liveStringLabel.font = .setFont(.caption2())
        liveStringLabel.text = "live"
        
        slider.setThumbImage(renderThumbImage(size: CGSize(width: 10, height: 10)), for: .normal)
        slider.minimumTrackTintColor = DesignSystemAsset.Color.mainGreen.color
        slider.maximumTrackTintColor = .gray
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
    
    public func updateSlider(to time: Float) {
        slider.setValue(time, animated: false)
    }
}

extension TimeControlView: TimeControlAction {
    var value: AnyPublisher<Float, Never> {
        $currentValue.eraseToAnyPublisher()
    }
    
}
