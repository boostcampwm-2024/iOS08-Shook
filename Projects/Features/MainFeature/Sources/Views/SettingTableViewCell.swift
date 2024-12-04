import UIKit

import BaseFeature
import DesignSystem
import EasyLayout

// MARK: - SettingTableViewCell

final class SettingTableViewCell: BaseTableViewCell {
    private let infoInputStackView = UIStackView()
    private let titleLabel = UILabel()
    private let inputTextView = UITextView()
    private let placeholderLabel = UILabel()
    private var placeholderValue = ""
    private let errorMessageLabel = UILabel()
    private var textDidChange: ((String) -> Void)?

    func configure(label: String, placeholder: String, textDidChange: ((String) -> Void)?) {
        titleLabel.text = label
        placeholderValue = placeholder
        placeholderLabel.text = placeholderValue
        self.textDidChange = textDidChange
    }

    override func setupViews() {
        inputTextView.delegate = self
        inputTextView.returnKeyType = .done

        errorMessageLabel.isHidden = true
        inputTextView.addSubview(placeholderLabel)

        infoInputStackView.addArrangedSubview(titleLabel)
        infoInputStackView.addArrangedSubview(inputTextView)

        contentView.addSubview(infoInputStackView)
        contentView.addSubview(errorMessageLabel)
    }

    override func setupStyles() {
        selectionStyle = .none

        infoInputStackView.axis = .horizontal
        infoInputStackView.spacing = 10

        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        titleLabel.font = .setFont(.body1(weight: .semiBold))
        titleLabel.textColor = .white

        inputTextView.textColor = .white
        inputTextView.textContainerInset = .zero
        inputTextView.isScrollEnabled = false
        inputTextView.font = .setFont(.body1(weight: .regular))

        placeholderLabel.font = .setFont(.body1(weight: .regular))
        placeholderLabel.textColor = DesignSystemAsset.Color.gray.color
        placeholderLabel.alpha = 0.5

        errorMessageLabel.preferredMaxLayoutWidth = errorMessageLabel.frame.width
        errorMessageLabel.font = .setFont(.caption1(weight: .regular))
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.lineBreakMode = .byWordWrapping
        errorMessageLabel.textColor = DesignSystemAsset.Color.errorRed.color
    }

    override func setupLayouts() {
        infoInputStackView.ezl.makeConstraint {
            $0.horizontal(to: contentView, padding: 30)
                .top(to: contentView, offset: 27)
        }

        placeholderLabel.ezl.makeConstraint {
            $0.centerY(to: inputTextView)
                .leading(to: inputTextView, offset: 10)
        }

        errorMessageLabel.ezl.makeConstraint {
            $0.top(to: inputTextView.ezl.bottom, offset: 10)
                .leading(to: inputTextView)
                .trailing(to: inputTextView)
                .bottom(to: contentView)
        }
    }

    func setErrorMessage(message: String?) {
        if let message, placeholderLabel.text != placeholderValue {
            errorMessageLabel.text = message
            errorMessageLabel.isHidden = false
        } else {
            errorMessageLabel.text = nil
            errorMessageLabel.isHidden = true
        }
    }
}

// MARK: UITextViewDelegate

extension SettingTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.text = textView.text.isEmpty ? placeholderValue : ""
        textDidChange?(textView.text)

        guard let tableView = superview as? UITableView else { return }
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn _: NSRange, replacementText text: String) -> Bool {
        guard text == "\n" else { return true }
        textView.resignFirstResponder()
        return false
    }
}
