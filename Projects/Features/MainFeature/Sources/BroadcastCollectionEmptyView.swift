import UIKit

import BaseFeature
import DesignSystem

final class BroadcastCollectionEmptyView: BaseView {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private lazy var textStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
    private lazy var stackView = UIStackView(arrangedSubviews: [imageView, textStackView])
    
    override func setupViews() {
        addSubview(stackView)
        
        imageView.image = DesignSystemAsset.Image.tv48.image
        
        titleLabel.text = "아직 라이브 방송이 없어요!"
        
        subtitleLabel.text = "잠시 후 다시 확인해 주세요!"
    }
    
    override func setupStyles() {
        titleLabel.textColor = .white
        titleLabel.font = .setFont(.title())
        
        subtitleLabel.textColor = .gray
        subtitleLabel.font = .setFont(.body2())
        
        textStackView.axis = .vertical
        textStackView.spacing = 7
        textStackView.alignment = .center
        
        stackView.axis = .vertical
        stackView.spacing = 13
        stackView.alignment = .center
    }
    
    override func layoutSubviews() {
        let imageSize = min(bounds.width * 0.25, bounds.height * 0.2)
        
        imageView.ezl.makeConstraint {
            $0.size(with: imageSize)
        }
    }
    
    override func setupLayouts() {
        stackView.ezl.makeConstraint {
            $0.center(to: self)
        }
    }
}
