import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

final class ChatingCell: BaseTableViewCell {
    static let identifier: String = "ChatingCell"
    
    private let nameLabel = UILabel()
    private let detailLabel = UILabel()
    
    override func setupViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(detailLabel)
        
        nameLabel.text = "닉네임"
        
        detailLabel.text = "채팅 내용"
    }
    
    override func setupStyles() {
        nameLabel.textColor = .white
        nameLabel.font = .setFont(.caption1(weight: .bold))
        
        detailLabel.textColor = .white
        detailLabel.font = .setFont(.caption1())
    }
    
    override func setupLayouts() {
        nameLabel.ezl.makeConstraint {
            $0.leading(to: contentView)
                .vertical(to: contentView)
        }
        
        detailLabel.ezl.makeConstraint {
            $0.leading(to: nameLabel.ezl.trailing, offset: 15)
                .vertical(to: contentView)
                .trailing(to: contentView)
        }
    }
}
