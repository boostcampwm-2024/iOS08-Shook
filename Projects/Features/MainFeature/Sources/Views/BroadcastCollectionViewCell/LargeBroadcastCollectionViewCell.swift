import UIKit

import BaseFeature
import DesignSystem
import EasyLayout

final class LargeBroadcastCollectionViewCell: BaseCollectionViewCell, ThumbnailViewContainer {
    let thumbnailView = ThumbnailView(with: .large)

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let liveBadgeLabel = PaddingLabel()

    override func setupViews() {
        liveBadgeLabel.text = "L I V E"

        contentView.addSubview(thumbnailView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
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
        }

        descriptionLabel.ezl.makeConstraint {
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
        liveBadgeLabel.textInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        liveBadgeLabel.backgroundColor = DesignSystemAsset.Color.mainGreen.color
        liveBadgeLabel.textAlignment = .center
        liveBadgeLabel.font = .setFont(.caption1(weight: .bold))
        liveBadgeLabel.layer.cornerRadius = 16
        liveBadgeLabel.clipsToBounds = true

        titleLabel.font = .setFont(.body1())
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping

        descriptionLabel.font = .setFont(.body2())
        descriptionLabel.textColor = .gray
        descriptionLabel.numberOfLines = 2
        descriptionLabel.lineBreakMode = .byWordWrapping
    }

    func configure(channel: Channel) {
        thumbnailView.configure(with: channel.thumbnailImageURLString)
        titleLabel.text = channel.name
        descriptionLabel.text = channel.owner + (channel.description.isEmpty ? "" : " • \(channel.description)")
    }
}
