import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

final class SmallCollectionViewCell: BaseCollectionViewCell {
    static let identifier = "SmallCollectionViewCell"
    
    private let thumnail = UIImageView()
    private let stack = UIStackView()
    
    private let title = UILabel()
    private let subtitle1 = UILabel()
    private let subtitle2 = UILabel()
    
    override func setupViews() {
        addSubview(thumnail)
        addSubview(stack)
        
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(subtitle1)
        stack.addArrangedSubview(subtitle2)
    }
    
    override func setupLayouts() {
        thumnail.ezl.makeConstraint {
            $0.leading(to: contentView.ezl.leading)
                .vertical(to: contentView)
                .width(164)
                .height(103)
        }
        
        stack.axis = .vertical
        stack.spacing = 4
        stack.ezl.makeConstraint {
            $0.trailing(to: thumnail.ezl.trailing, offset: 8)
                .centerY(to: thumnail)
        }
    }
    
    override func setupStyles() {
        thumnail.contentMode = .scaleAspectFill
        thumnail.clipsToBounds = true
        
        title.font = .setFont(.body2())
        title.numberOfLines = 2
        
        subtitle1.font = .setFont(.caption1())
        subtitle1.numberOfLines = 1
    }
    
    func configure(image: UIImage?, title: String, subtitle1: String, subtitle2: String) {
        self.thumnail.image = image
        self.title.text = title
        self.subtitle1.text = subtitle1
        self.subtitle2.text = subtitle2
    }
}
