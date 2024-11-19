import BaseFeature
import DesignSystem
import EasyLayoutModule
import UIKit

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
        self.backgroundColor = .black
    }
    
    override func setupLayouts() {
        stackView.ezl.makeConstraint {
            $0.diagonal(to: self, padding: 20)
        }
        
    }
    
    override func setupStyles() {
        titleLabel.font = .setFont(.body2())
        descriptionLabel.font = .setFont(.caption1())
        titleLabel.textColor = .white
        descriptionLabel.textColor = .white
        
        titleLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 1
    }
}

extension LiveStreamInfoView {
    public func fillLabels(with model: (String, String)) {
        titleLabel.text = model.0
        descriptionLabel.text = model.1
    }
}
