import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

final class SmallBroadcastCollectionViewCell: BaseCollectionViewCell, ThumbnailViewContainer {
    let thumbnailView = ThumbnailView(with: .small)
    
    private let descriptionStack = UIStackView()
    private let titleLabel = UILabel()
    private let liveBadgeLabel = PaddingLabel()

    override func setupViews() {
        liveBadgeLabel.text = "L I V E"
        
        contentView.addSubview(thumbnailView)
        contentView.addSubview(liveBadgeLabel)
        contentView.addSubview(descriptionStack)
        
        descriptionStack.addArrangedSubview(titleLabel)
    }
    
    override func setupLayouts() {
        thumbnailView.ezl.makeConstraint {
            $0.leading(to: contentView)
                .centerY(to: contentView)
                .width(contentView.frame.width * 0.45)
                .height(contentView.frame.width * 0.45 * 0.5625)
        }
        
        descriptionStack.ezl.makeConstraint {
            $0.leading(to: thumbnailView.imageView.ezl.trailing, offset: 8)
                .trailing(to: contentView, offset: -16)
                .centerY(to: thumbnailView)
        }
        
        liveBadgeLabel.ezl.makeConstraint {
            $0.top(to: thumbnailView.imageView, offset: 8)
                .leading(to: thumbnailView.imageView, offset: 8)
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
    }
    
    func configure(image: UIImage?, title: String) {
        self.thumbnailView.configure(with: image)
        self.titleLabel.text = title
    }
}
