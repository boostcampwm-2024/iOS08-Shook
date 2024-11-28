import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

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
        liveBadgeLabel.textColor = .white
        liveBadgeLabel.textAlignment = .center
        liveBadgeLabel.font = .setFont(.caption1(weight: .bold))
        liveBadgeLabel.layer.cornerRadius = 16
        liveBadgeLabel.clipsToBounds = true
        
        titleLabel.font = .setFont(.body1())
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping
        
        descriptionLabel.font = .setFont(.body2())
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 2
        descriptionLabel.lineBreakMode = .byWordWrapping
    }
    
    func configure(channel: Channel) {
        loadAsyncImage(with: channel.thumbnailImageURLString)
        self.titleLabel.text = channel.name
        self.descriptionLabel.text = "\(channel.owner) • \(channel.description)"
    }
    
    private func loadAsyncImage(with imageURLString: String) {
        guard let url = URL(string: imageURLString) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard error == nil,
                  let data else { return }
            DispatchQueue.main.async {
                self?.thumbnailView.configure(with: UIImage(data: data))
            }
        }.resume()
    }
}
