import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

final class SettingTableViewCell: BaseTableViewCell {
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let textView = UITextView()
    private let placeholder = UILabel()
    private var placeholderValue = ""
    private let errorMessageLabel = UILabel()
    private var textDidChange: ((String) -> Void)?
    
    func configure(label: String, placeholder: String, textDidChange: ((String) -> Void)?) {
        titleLabel.text = label
        self.placeholderValue = placeholder
        self.placeholder.text = placeholderValue
        self.textDidChange = textDidChange
    }
        
    override func setupViews() {
        textView.delegate = self
        
        errorMessageLabel.isHidden = true
        textView.addSubview(placeholder)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textView)
        contentView.addSubview(stackView)
        contentView.addSubview(errorMessageLabel)
    }
    
    override func setupStyles() {
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        textView.textContainerInset = .zero
        stackView.axis = .horizontal
        stackView.spacing = 10
        selectionStyle = .none
        textView.isScrollEnabled = false
        
        // Fonts
        titleLabel.font = .setFont(.body1(weight: .semiBold))
        textView.font = .setFont(.body1(weight: .regular))
        placeholder.font = .setFont(.body1(weight: .regular))
        errorMessageLabel.font = .setFont(.caption1(weight: .regular))
        
        // Colors
        contentView.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
        stackView.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
        placeholder.textColor = DesignSystemAsset.Color.gray.color
        textView.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
        titleLabel.textColor = .white
        textView.textColor = .white
        errorMessageLabel.textColor = DesignSystemAsset.Color.errorRed.color
        
        // Alpha
        placeholder.alpha = 0.5
    }
    
    override func setupLayouts() {
        stackView.ezl.makeConstraint {
            $0.horizontal(to: contentView, padding: 10)
                .vertical(to: contentView, padding: 27)
        }
        
        placeholder.ezl.makeConstraint {
            $0.centerY(to: textView)
                .leading(to: textView, offset: 10)
        }
        
        errorMessageLabel.ezl.makeConstraint {
            $0.top(to: textView.ezl.bottom, offset: 10)
                .leading(to: textView)
        }
    }
    
    func setErrorMessage(message: String?) {
        if let message, placeholder.text != placeholderValue {
            errorMessageLabel.text = message
            errorMessageLabel.isHidden = false
        } else {
            errorMessageLabel.text = nil
            errorMessageLabel.isHidden = true
        }
    }
}

// MARK: Text View의 Delegate
extension SettingTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholder.text = textView.text.isEmpty ? placeholderValue : ""
        textDidChange?(textView.text)
        
        if let tableView = self.superview as? UITableView {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}
