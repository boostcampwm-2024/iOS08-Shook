import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

final class SmallCollectionViewCell: BaseCollectionViewCell {
    static let identifier = String(describing: type(of: SmallCollectionViewCell.self))
    
    private let thumbnail = UIImageView()
    private let stack = UIStackView()
    
    private let title = UILabel()
    private let subtitle1 = UILabel()
    private let subtitle2 = UILabel()
    
    override func setupViews() {
        contentView.addSubview(thumbnail)
        contentView.addSubview(stack)
        
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(subtitle1)
        stack.addArrangedSubview(subtitle2)
    }
    
    override func setupLayouts() {
        thumbnail.ezl.makeConstraint {
            $0.leading(to: contentView)
                .width(164)
                .height(103)
        }
        
        stack.axis = .vertical
        stack.spacing = 4
        stack.ezl.makeConstraint {
            $0.leading(to: thumbnail.ezl.trailing, offset: 8)
                .centerY(to: thumbnail)
        }
    }
    
    override func setupStyles() {
        thumbnail.contentMode = .scaleAspectFill
        thumbnail.clipsToBounds = true
        
        title.font = .setFont(.body2())
        title.numberOfLines = 2
        
        subtitle1.font = .setFont(.caption1())
        subtitle1.numberOfLines = 1
        
        subtitle2.font = .setFont(.caption1())
        subtitle1.numberOfLines = 1
    }
    
    func configure(image: UIImage?, title: String, subtitle1: String, subtitle2: String) {
        self.thumbnail.image = image
        self.title.text = title
        self.subtitle1.text = subtitle1
        self.subtitle2.text = subtitle2
    }
}
