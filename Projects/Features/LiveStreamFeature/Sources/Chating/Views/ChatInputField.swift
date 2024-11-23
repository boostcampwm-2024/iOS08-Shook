import Combine
import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

protocol ChatInputFieldAction {
    var sendButtonDidTap: AnyPublisher<ChatInfo?, Never> { get }
}

final class ChatInputField: BaseView {
    private let heartButton = UIButton()
    private let inputField = UITextView()
    private let sendButton = UIButton()
    private let placeholder = UILabel()
    
    private let clipView = UIView()
    
    private var inputFieldHeightContraint: NSLayoutConstraint!
    
    @Published private var sendButtonDidTapPublisher: ChatInfo?

    override func setupViews() {
        addSubview(heartButton)
        addSubview(clipView)
        
        clipView.addSubview(inputField)
        clipView.addSubview(sendButton)
        
        heartButton.setImage(DesignSystemAsset.Image.heart24.image, for: .normal)
        heartButton.setContentHuggingPriority(.required, for: .horizontal)
        
        inputField.addSubview(placeholder)
        inputField.textContainerInset = .zero
        inputField.delegate = self
        
        placeholder.text = "재미있는 이야기를 시작해 보세요!"

        sendButton.setContentHuggingPriority(.required, for: .horizontal)
        sendButton.setImage(
            DesignSystemAsset.Image.send24.image.withRenderingMode(.alwaysTemplate),
            for: .normal
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
        placeholder.textColor = .systemGray6
        
        sendButton.tintColor = .white
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
                #warning("Chating User Name 추후 수정")
                sendButtonDidTapPublisher = ChatInfo(
                    name: "홍길동",
                    message: inputField.text
                )
                inputField.text = ""
                textViewDidChange(inputField)
            },
            for: .touchUpInside
        )
    }
}

extension ChatInputField: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            clipView.layer.borderColor = UIColor.white.cgColor
            sendButton.tintColor = .white
            placeholder.isHidden = false
        } else {
            clipView.layer.borderColor = DesignSystemAsset.Color.mainGreen.color.cgColor
            sendButton.tintColor = DesignSystemAsset.Color.mainGreen.color
            placeholder.isHidden = true
        }
        
        inputFieldHeightContraint.constant = textView.contentSize.height
        
        layoutIfNeeded()
    }
}

extension ChatInputField: ChatInputFieldAction {
    var sendButtonDidTap: AnyPublisher<ChatInfo?, Never> {
        $sendButtonDidTapPublisher.dropFirst().eraseToAnyPublisher()
    }
}
