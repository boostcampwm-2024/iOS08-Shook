import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

final class LargeBroadcastCollectionViewCell: BaseCollectionViewCell, ThumbnailViewContainer {
    let thumbnailView = ThumbnailView(with: .large)
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let liveBadgeLabel = PaddingLabel()
    
    override func setupViews() {
        liveBadgeLabel.text = "L I V E"
        
        contentView.addSubview(thumbnailView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(liveBadgeLabel)
    }
    
    override func setupLayouts() {
        thumbnailView.ezl.makeConstraint {
            $0.top(to: contentView)
                .horizontal(to: contentView)
                .height(contentView.frame.width * 0.5625)
        }
        
        titleLabel.ezl.makeConstraint {
            $0.top(to: thumbnailView.imageView.ezl.bottom, offset: 6)
                .horizontal(to: contentView, padding: 20)
                .bottom(to: subtitleLabel.ezl.top)
        }
        
        subtitleLabel.ezl.makeConstraint {
            $0.top(to: titleLabel.ezl.bottom, offset: 6)
                .horizontal(to: contentView, padding: 20)
                .bottom(to: contentView)
        }
        
        liveBadgeLabel.ezl.makeConstraint {
            $0.top(to: thumbnailView.imageView, offset: 12)
                .leading(to: thumbnailView.imageView, offset: 12)
        }
    }
    
    override func setupStyles() {
        titleLabel.font = .setFont(.body1())
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping
        
        subtitleLabel.font = .setFont(.body2())
        subtitleLabel.numberOfLines = 1
        
        liveBadgeLabel.textInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        liveBadgeLabel.backgroundColor = DesignSystemAsset.Color.mainGreen.color
        liveBadgeLabel.textColor = .white
        liveBadgeLabel.textAlignment = .center
        liveBadgeLabel.font = .setFont(.caption1(weight: .bold))
        liveBadgeLabel.layer.cornerRadius = 16
        liveBadgeLabel.clipsToBounds = true
    }
    
    func configure(image: UIImage?, title: String, subtitle: String) {
        self.thumbnailView.configure(with: image)
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        contentView.layoutIfNeeded()
    }
}
