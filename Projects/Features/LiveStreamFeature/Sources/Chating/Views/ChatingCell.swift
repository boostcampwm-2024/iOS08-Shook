import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

final class ChatingCell: BaseTableViewCell {    
    private let nameLabel = UILabel()
    private let detailLabel = UILabel()
    
    override func setupViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(detailLabel)
        
        nameLabel.text = "닉네임"
        nameLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        detailLabel.text = "채팅 내용"
    }
    
    override func setupStyles() {
        backgroundColor = .clear
        
        nameLabel.textColor = .white
        nameLabel.font = .setFont(.caption1(weight: .bold))
        
        detailLabel.textColor = .white
        detailLabel.font = .setFont(.caption1())
    }
    
    override func setupLayouts() {
        nameLabel.ezl.makeConstraint {
            $0.leading(to: contentView, offset: 20)
                .vertical(to: contentView, padding: 6)
        }
        
        detailLabel.ezl.makeConstraint {
            $0.leading(to: nameLabel.ezl.trailing, offset: 15)
                .vertical(to: contentView, padding: 6)
                .trailing(to: contentView, offset: -20)
        }
    }
}
