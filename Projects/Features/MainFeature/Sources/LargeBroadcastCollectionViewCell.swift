import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

final class LargeBroadcastCollectionViewCell: BaseCollectionViewCell, ThumbnailViewContainer {
    let thumbnailView = ThumbnailView(with: .large)
    
    private let titleLabel = UILabel()
    private let liveBadgeLabel = PaddingLabel()
    
    override func setupViews() {
        liveBadgeLabel.text = "L I V E"
        
        contentView.addSubview(thumbnailView)
        contentView.addSubview(titleLabel)
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
                .bottom(to: contentView)
        }
        
        liveBadgeLabel.ezl.makeConstraint {
            $0.top(to: thumbnailView.imageView, offset: 12)
                .leading(to: thumbnailView.imageView, offset: 12)
        }
    }
    
    override func setupStyles() {
        liveBadgeLabel.textInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        liveBadgeLabel.backgroundColor = DesignSystemAsset.Color.mainGreen.color
        liveBadgeLabel.textColor = .white
        liveBadgeLabel.textAlignment = .center
        liveBadgeLabel.font = .setFont(.caption1(weight: .bold))
        liveBadgeLabel.layer.cornerRadius = 16
        liveBadgeLabel.clipsToBounds = true
        
        titleLabel.font = .setFont(.body1())
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping
    }
    
    func configure(id: String, title: String, viewmodel: BroadcastCollectionViewModel) {
    }
}
