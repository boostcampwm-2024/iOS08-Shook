import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

final class SmallCollectionViewCell: BaseCollectionViewCell {
    static var identifier: String { String(describing: Self.self) }

    private let thumbnail = UIImageView()
    private let descriptionStack = UIStackView()
    
    private let title = UILabel()
    private let subtitle1 = UILabel()
    private let subtitle2 = UILabel()
    
    private let liveCircle = UIView()
    
    override func setupViews() {
        contentView.addSubview(thumbnail)
        contentView.addSubview(liveCircle)
        contentView.addSubview(descriptionStack)
        
        descriptionStack.addArrangedSubview(title)
        descriptionStack.addArrangedSubview(subtitle1)
        descriptionStack.addArrangedSubview(subtitle2)
    }
    
    override func setupLayouts() {
        thumbnail.ezl.makeConstraint {
            $0.leading(to: contentView)
                .width(contentView.frame.width * 0.45)
                .height(contentView.frame.width * 0.45 * 0.5625)
        }
        
        descriptionStack.ezl.makeConstraint {
            $0.leading(to: thumbnail.ezl.trailing, offset: 8)
                .trailing(to: contentView)
                .centerY(to: thumbnail)
        }
        
        liveCircle.ezl.makeConstraint {
            $0.top(to: thumbnail, offset: 12)
                .leading(to: thumbnail, offset: 12)
                .size(with: 8)
        }
    }
    
    override func setupStyles() {
        thumbnail.contentMode = .scaleAspectFill
        thumbnail.clipsToBounds = true
        thumbnail.layer.cornerRadius = 8
        
        liveCircle.backgroundColor = DesignSystemAsset.Color.mainGreen.color
        liveCircle.layer.cornerRadius = 4
        liveCircle.clipsToBounds = true
        
        descriptionStack.axis = .vertical
        descriptionStack.spacing = 4
        
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
