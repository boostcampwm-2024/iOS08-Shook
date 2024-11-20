import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule


final class LiveStreamInfoView: BaseView {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    override func setupViews() {
        self.addSubview(stackView)
        self.backgroundColor = DesignSystemAsset.Color.darkGray.color
    }
    
    override func setupLayouts() {
        stackView.ezl.makeConstraint {
            $0.diagonal(to: self, padding: 20)
        }
    }
    
    override func setupStyles() {
        titleLabel.font = .setFont(.body2())
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white
        
        descriptionLabel.font = .setFont(.caption1())
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 1
    }
}

extension LiveStreamInfoView {
    public func configureUI(with model: (String, String)) {
        titleLabel.text = model.0
        descriptionLabel.text = model.1
    }
}
