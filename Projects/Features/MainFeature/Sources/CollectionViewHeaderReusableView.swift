import UIKit

import DesignSystem
import EasyLayoutModule

class CollectionViewHeaderReusableView: UICollectionReusableView {
    static var identifier = "CollectionViewHeaderReusableView"
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupLayouts()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupStyles()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    private func setupViews() {
        addSubview(label)
    }
    
    private func setupLayouts() {
        label.ezl.makeConstraint {
            $0.diagonal(to: self)
        }
    }
    
    private func setupStyles() {
        label.font = .setFont(.body1())
    }
    
    func configure(with title: String) {
        label.text = title
    }
}
