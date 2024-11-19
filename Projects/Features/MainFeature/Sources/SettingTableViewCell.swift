import UIKit

import BaseFeature
import EasyLayoutModule

class SettingTableViewCell: BaseTableViewCell {
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let textView = UITextView()
    private let placeholder = UILabel()
    private var textDidChange: ((String?) -> Void)?
    
    func configure(label: String, placeholder: String, textDidChange: ((String?) -> Void)?) {
        titleLabel.text = label
        self.placeholder.text = placeholder
        self.textDidChange = textDidChange
    }
        
    override func setupViews() {
        textView.delegate = self
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textView)
        contentView.addSubview(stackView)
    }
    
    override func setupStyles() {
        selectionStyle = .none
        stackView.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
        textView.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
        titleLabel.textColor = .white
        textView.textColor = .white
    }
    
    override func setupLayouts() {
        stackView.ezl.makeConstraint {
            $0.diagonal(to: contentView)
        }
    }
}

extension SettingTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textDidChange?(textView.text)
    }
}

extension UITableViewCell {
    static var identifier: String {
        String(describing: self)
    }
}
