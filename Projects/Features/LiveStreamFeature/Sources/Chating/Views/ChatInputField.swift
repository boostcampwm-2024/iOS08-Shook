import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

final class ChatInputField: BaseView {
    private let heartButton = UIButton()
    private let inputField = UITextView()
    private let sendButton = UIButton()
    
    private let clipView = UIView()
    
    private var inputFieldHeightContraint: NSLayoutConstraint!
    
    override func setupViews() {
        addSubview(heartButton)
        addSubview(clipView)
        
        clipView.addSubview(inputField)
        clipView.addSubview(sendButton)
        
        heartButton.setImage(DesignSystemAsset.Image.heart24.image, for: .normal)
        heartButton.setContentHuggingPriority(.required, for: .horizontal)
        
        inputField.textContainerInset = .zero
        inputField.delegate = self

        sendButton.setContentHuggingPriority(.required, for: .horizontal)
        sendButton.setImage(
            DesignSystemAsset.Image.send24.image.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        sendButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    override func setupStyles() {
        backgroundColor = DesignSystemColors.Color.darkGray
        
        clipView.backgroundColor = .clear
        clipView.layer.cornerRadius = 20
        clipView.clipsToBounds = true
        clipView.layer.borderWidth = 1
        clipView.layer.borderColor = UIColor.white.cgColor
        
        inputField.font = .setFont(.body2())
        inputField.backgroundColor = .clear
        inputField.textColor = .white
        
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
        
        sendButton.ezl.makeConstraint {
            $0.trailing(to: clipView, offset: -15)
                .bottom(to: clipView, offset: -8)
        }
    }
}

extension ChatInputField: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            clipView.layer.borderColor = UIColor.white.cgColor
            sendButton.tintColor = .white
        } else {
            clipView.layer.borderColor = DesignSystemAsset.Color.mainGreen.color.cgColor
            sendButton.tintColor = DesignSystemAsset.Color.mainGreen.color
        }
        
        inputFieldHeightContraint.constant = textView.contentSize.height
        
        layoutIfNeeded()
    }
}
