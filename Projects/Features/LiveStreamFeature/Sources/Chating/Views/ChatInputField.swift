import Combine
import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

final class ChatInputField: BaseView {
    private let heartButton = UIButton()
    private let inputField = UITextView()
    private let sendButton = UIButton()
    private let placeholder = UILabel()
    
    private let clipView = UIView()
    
    private var inputFieldHeightContraint: NSLayoutConstraint!
    private let heartLayer = CAEmitterLayer()
    private var heartEmitterCell = CAEmitterCell()
    
    @Published var sendButtonDidTapPublisher: ChatInfo?

    override func setupViews() {
        addSubview(heartButton)
        addSubview(clipView)
        
        clipView.addSubview(inputField)
        clipView.addSubview(sendButton)
        
        heartLayer.emitterCells = [heartEmitterCell]
        
        heartButton.setImage(DesignSystemAsset.Image.heart24.image, for: .normal)
        heartButton.setContentHuggingPriority(.required, for: .horizontal)
        
        heartEmitterCell.contents = DesignSystemAsset.Image.heart24.image.cgImage
        heartEmitterCell.lifetime = 4
        heartEmitterCell.birthRate = 1
        heartEmitterCell.scale = 0.5
        heartEmitterCell.scaleRange = 0.2
        heartEmitterCell.emissionLongitude = -CGFloat.pi / 5 /// 위쪽보다 살짝 오른쪽으로 가도록 설정
        heartEmitterCell.emissionRange = 0.9 /// 퍼지는 각도 조절
        heartEmitterCell.velocity = 50 /// 1초 기준 속도
        heartEmitterCell.velocityRange = 30
        heartEmitterCell.yAcceleration = -50
        
        inputField.addSubview(placeholder)
        inputField.textContainerInset = .zero
        inputField.delegate = self
        
        placeholder.text = "재미있는 이야기를 시작해 보세요!"

        sendButton.setContentHuggingPriority(.required, for: .horizontal)
        sendButton.setImage(
            DesignSystemAsset.Image.send24.image.withTintColor(DesignSystemAsset.Color.mainGreen.color),
            for: .normal
        )
        sendButton.setImage(
            DesignSystemAsset.Image.send24.image.withTintColor(.white),
            for: .disabled
        )
        sendButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    override func setupStyles() {
        backgroundColor = DesignSystemAsset.Color.darkGray.color
        
        clipView.backgroundColor = .clear
        clipView.layer.cornerRadius = 20
        clipView.clipsToBounds = true
        clipView.layer.borderWidth = 1
        clipView.layer.borderColor = UIColor.white.cgColor
        
        inputField.font = .setFont(.body2())
        inputField.backgroundColor = .clear
        inputField.textColor = .white
        
        placeholder.font = .setFont(.body2())
        placeholder.textColor = DesignSystemAsset.Color.gray.color
        
        sendButton.isEnabled = false
    }
    
    override func setupLayouts() {
        heartButton.ezl.makeConstraint {
            $0.leading(to: self, offset: 20)
                .bottom(to: self, offset: -16)
        }
        
        clipView.ezl.makeConstraint {
            $0.vertical(to: self, padding: 10)
                .leading(to: heartButton.ezl.trailing, offset: 10)
                .trailing(to: self, offset: -20)
                .height(min: 40)
        }
        
        inputField.ezl.makeConstraint {
            $0.vertical(to: clipView, padding: 10)
                .leading(to: clipView, offset: 16)
                .trailing(to: sendButton.ezl.leading, offset: -12)
                .height(max: 100)
        }
        
        inputFieldHeightContraint = inputField.heightAnchor.constraint(equalToConstant: 20)
        inputFieldHeightContraint.priority = .defaultLow
        inputFieldHeightContraint.isActive = true
        
        placeholder.ezl.makeConstraint {
            $0.top(to: inputField)
                .leading(to: inputField, offset: 5)
        }
        
        sendButton.ezl.makeConstraint {
            $0.trailing(to: clipView, offset: -15)
                .bottom(to: clipView, offset: -8)
        }
    }
    
    override func setupActions() {
        sendButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                #warning("chatting User Name 추후 수정")
                sendButtonDidTapPublisher = ChatInfo(
                    owner: .user(name: "홍길동"),
                    message: inputField.text
                )
                inputField.text = ""
                textViewDidChange(inputField)
            },
            for: .touchUpInside
        )
        heartButton.addTarget(self, action: #selector(didTapHeartButton), for: .touchUpInside)
    }
    
    @objc
    private func didTapHeartButton() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        heartLayer.emitterPosition = CGPoint(x: heartButton.frame.midX, y: heartButton.frame.midY)
        heartLayer.birthRate = 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            self?.heartLayer.birthRate = 0
        }
        layer.addSublayer(heartLayer)
        
    }
}

extension ChatInputField: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            clipView.layer.borderColor = UIColor.white.cgColor
            sendButton.isEnabled = false
            placeholder.isHidden = false
        } else {
            clipView.layer.borderColor = DesignSystemAsset.Color.mainGreen.color.cgColor
            sendButton.isEnabled = true
            placeholder.isHidden = true
        }
        
        inputFieldHeightContraint.constant = textView.contentSize.height
        
        layoutIfNeeded()
    }
}
