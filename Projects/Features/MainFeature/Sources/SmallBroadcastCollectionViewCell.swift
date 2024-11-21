import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

final class SmallBroadcastCollectionViewCell: BaseCollectionViewCell, ThumbnailViewContainer {
    let thumbnailView = ThumbnailView(for: .small)
    
    private let descriptionStack = UIStackView()
    private let titleLabel = UILabel()
    private let subtitle1Label = UILabel()
    private let subtitle2Label = UILabel()
    private let liveBadgeLabel = PaddingLabel()

    override func setupViews() {
        liveBadgeLabel.text = "L I V E"
        
        contentView.addSubview(thumbnailView)
        contentView.addSubview(liveBadgeLabel)
        contentView.addSubview(descriptionStack)
        
        descriptionStack.addArrangedSubview(titleLabel)
        descriptionStack.addArrangedSubview(subtitle1Label)
        descriptionStack.addArrangedSubview(subtitle2Label)
    }
    
    override func setupLayouts() {
        thumbnailView.ezl.makeConstraint {
            $0.leading(to: contentView)
                .centerY(to: contentView)
                .width(contentView.frame.width * 0.45)
                .height(contentView.frame.width * 0.45 * 0.5625)
        }
        
        descriptionStack.ezl.makeConstraint {
            $0.leading(to: thumbnailView.ezl.trailing, offset: 8)
                .trailing(to: contentView)
                .centerY(to: thumbnailView)
        }
        
        liveBadgeLabel.ezl.makeConstraint {
            $0.top(to: thumbnailView, offset: 8)
                .leading(to: thumbnailView, offset: 8)
        }
    }
    
    override func setupStyles() {
        liveBadgeLabel.textInsets = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6)
        liveBadgeLabel.backgroundColor = DesignSystemAsset.Color.mainGreen.color
        liveBadgeLabel.textColor = .white
        liveBadgeLabel.textAlignment = .center
        liveBadgeLabel.font = .setFont(.caption2(weight: .bold))
        liveBadgeLabel.layer.cornerRadius = 8
        liveBadgeLabel.clipsToBounds = true
        
        descriptionStack.axis = .vertical
        descriptionStack.spacing = 4
        
        titleLabel.font = .setFont(.body2())
        titleLabel.numberOfLines = 2
        
        subtitle1Label.font = .setFont(.caption1())
        subtitle1Label.numberOfLines = 1
        
        subtitle2Label.font = .setFont(.caption1())
        subtitle1Label.numberOfLines = 1
    }
    
    func configure(image: UIImage?, title: String, subtitle1: String, subtitle2: String) {
        self.thumbnailView.configure(with: image)
        self.titleLabel.text = title
        self.subtitle1Label.text = subtitle1
        self.subtitle2Label.text = subtitle2
    }
}
