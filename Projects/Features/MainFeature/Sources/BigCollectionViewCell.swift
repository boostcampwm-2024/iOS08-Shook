import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

final class BigCollectionViewCell: BaseCollectionViewCell {
    static let identifier = String(describing: type(of: BigCollectionViewCell.self))
    
    private let thumbnail = UIImageView()
    private let title = UILabel()
    private let subtitle = UILabel()
    
    override func setupViews() {
        contentView.addSubview(thumbnail)
        contentView.addSubview(title)
        contentView.addSubview(subtitle)
    }
    
    override func setupLayouts() {
        thumbnail.ezl.makeConstraint {
            $0.top(to: contentView)
                .horizontal(to: contentView)
                .height(213)
        }
        
        title.ezl.makeConstraint {
            $0.top(to: thumbnail.ezl.bottom, offset: 4)
                .horizontal(to: contentView)
        }
        
        subtitle.ezl.makeConstraint {
            $0.top(to: title.ezl.bottom, offset: 4)
                .horizontal(to: contentView)
        }
    }
    
    override func setupStyles() {
        thumbnail.contentMode = .scaleAspectFill
        thumbnail.clipsToBounds = true
        
        title.font = .setFont(.body2())
        title.numberOfLines = 2
        
        subtitle.font = .setFont(.caption1())
        subtitle.numberOfLines = 1
    }
    
    func configure(image: UIImage?, title: String, subtitle: String) {
        self.thumbnail.image = image
        self.title.text = title
        self.subtitle.text = subtitle
    }
}
