import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

final class BigCollectionViewCell: BaseCollectionViewCell {
    static var identifier: String { String(describing: Self.self) }
    
    private let thumbnail = UIImageView()
    private let title = UILabel()
    private let subtitle = UILabel()
    private let liveBadge = PaddingUILabel()
    
    override func setupViews() {
        liveBadge.text = "L I V E"
        
        contentView.addSubview(thumbnail)
        contentView.addSubview(title)
        contentView.addSubview(subtitle)
        contentView.addSubview(liveBadge)
    }
    
    override func setupLayouts() {
        thumbnail.ezl.makeConstraint {
            $0.top(to: contentView)
                .horizontal(to: contentView)
                .height(contentView.frame.width * 0.5625)
        }
        
        title.ezl.makeConstraint {
            $0.top(to: thumbnail.ezl.bottom, offset: 4)
                .horizontal(to: contentView)
        }
        
        subtitle.ezl.makeConstraint {
            $0.top(to: title.ezl.bottom, offset: 4)
                .horizontal(to: contentView)
        }
        
        liveBadge.ezl.makeConstraint {
            $0.top(to: thumbnail, offset: 12)
                .leading(to: thumbnail, offset: 12)
        }
    }
    
    override func setupStyles() {
        thumbnail.contentMode = .scaleAspectFill
        thumbnail.clipsToBounds = true
        thumbnail.layer.cornerRadius = 16
        
        title.font = .setFont(.body2())
        title.numberOfLines = 2
        
        subtitle.font = .setFont(.caption1())
        subtitle.numberOfLines = 1
        
        liveBadge.textInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        liveBadge.backgroundColor = DesignSystemAsset.Color.mainGreen.color
        liveBadge.textColor = .white
        liveBadge.textAlignment = .center
        liveBadge.font = .setFont(.caption1(weight: .bold))
        liveBadge.layer.cornerRadius = 16
        liveBadge.clipsToBounds = true
    }
    
    func configure(image: UIImage?, title: String, subtitle: String) {
        self.thumbnail.image = image
        self.title.text = title
        self.subtitle.text = subtitle
    }
}
