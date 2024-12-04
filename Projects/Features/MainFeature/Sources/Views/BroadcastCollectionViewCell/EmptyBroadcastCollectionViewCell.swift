import UIKit

import BaseFeature
import DesignSystem
import EasyLayout

final class EmptyBroadcastCollectionViewCell: BaseCollectionViewCell {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    private lazy var textStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
    private lazy var stackView = UIStackView(arrangedSubviews: [imageView, textStackView])

    override func setupViews() {
        contentView.addSubview(stackView)

        imageView.image = DesignSystemAsset.Image.tv48.image

        titleLabel.text = "아직 라이브 방송이 없어요!"

        subtitleLabel.text = "잠시 후 다시 확인해 주세요!"
    }

    override func setupStyles() {
        titleLabel.font = .setFont(.title())

        subtitleLabel.textColor = .gray
        subtitleLabel.font = .setFont(.body2())

        textStackView.axis = .vertical
        textStackView.spacing = 12
        textStackView.alignment = .center

        stackView.axis = .vertical
        stackView.spacing = 7
        stackView.alignment = .center

        contentView.backgroundColor = .systemBackground
    }

    override func setupLayouts() {
        stackView.ezl.makeConstraint {
            $0.center(to: contentView)
        }

        imageView.ezl.makeConstraint {
            $0.size(with: 117)
        }
    }
}
