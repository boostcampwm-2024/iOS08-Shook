import UIKit

import BaseFeature
import DesignSystem
import EasyLayout

final class SystemAlarmCell: BaseTableViewCell {
    private let contentLabel = UILabel()

    override func setupViews() {
        contentView.addSubview(contentLabel)
    }

    override func setupStyles() {
        backgroundColor = .clear

        contentLabel.textAlignment = .center
        contentLabel.textColor = DesignSystemAsset.Color.gray.color
        contentLabel.font = .setFont(.caption1())
    }

    override func setupLayouts() {
        contentLabel.ezl.makeConstraint {
            $0.diagonal(to: contentView)
        }
    }

    func configure(content: String) {
        contentLabel.text = content
    }
}
