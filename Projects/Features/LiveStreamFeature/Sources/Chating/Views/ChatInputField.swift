import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

final class ChatInputField: BaseView {
    private let heartButton = UIButton()
    private let inputField = UITextView()
    private let sendButton = UIButton()
    
    private let clipView = UIView()
    
    override func setupViews() {
        addSubview(heartButton)
        addSubview(clipView)
        
        clipView.addSubview(inputField)
        clipView.addSubview(sendButton)
        
        heartButton.setImage(DesignSystemAsset.Image.heart24.image, for: .normal)
        heartButton.setContentHuggingPriority(.required, for: .horizontal)
        
        inputField.isScrollEnabled = false
        inputField.textContainerInset = .zero

        sendButton.setContentHuggingPriority(.required, for: .horizontal)
        sendButton.setImage(DesignSystemAsset.Image.send24.image, for: .normal)
        sendButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    override func setupStyles() {
        backgroundColor = .gray
        
        clipView.backgroundColor = .clear
        clipView.layer.cornerRadius = 20
        clipView.clipsToBounds = true
        clipView.layer.borderWidth = 1
        clipView.layer.borderColor = UIColor.white.cgColor
        
        inputField.font = .setFont(.body2())
        inputField.backgroundColor = .clear
        inputField.textColor = .white
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
        }
        
        sendButton.ezl.makeConstraint {
            $0.trailing(to: clipView, offset: -15)
                .bottom(to: clipView, offset: -8)
        }
    }
}
