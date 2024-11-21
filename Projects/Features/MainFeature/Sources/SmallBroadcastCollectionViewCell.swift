import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

final class SmallBroadcastCollectionViewCell: BaseCollectionViewCell {
    private let thumbnail = UIImageView()
    
    private let descriptionStack = UIStackView()
    private let title = UILabel()
    private let subtitle1 = UILabel()
    private let subtitle2 = UILabel()
    
    private let liveBadge = PaddingLabel()

    override func setupViews() {
        liveBadge.text = "L I V E"
        
        contentView.addSubview(thumbnail)
        contentView.addSubview(liveBadge)
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
        
        liveBadge.ezl.makeConstraint {
            $0.top(to: thumbnail, offset: 8)
                .leading(to: thumbnail, offset: 8)
        }
    }
    
    override func setupStyles() {
        thumbnail.contentMode = .scaleAspectFill
        thumbnail.clipsToBounds = true
        thumbnail.layer.cornerRadius = 8
        
        liveBadge.textInsets = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6)
        liveBadge.backgroundColor = DesignSystemAsset.Color.mainGreen.color
        liveBadge.textColor = .white
        liveBadge.textAlignment = .center
        liveBadge.font = .setFont(.caption2(weight: .bold))
        liveBadge.layer.cornerRadius = 8
        liveBadge.clipsToBounds = true
        
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
