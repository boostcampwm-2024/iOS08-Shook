import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

final class ChatEmptyView: BaseView {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private lazy var textStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
    private lazy var stackView = UIStackView(arrangedSubviews: [imageView, textStackView])
    
    override func setupViews() {
        addSubview(stackView)
        
        imageView.image = DesignSystemAsset.Image.chat48.image
        
        titleLabel.text = "여기는 지금 조용하네요!"
        
        subtitleLabel.text = "첫 댓글로 스트리머와 소통을 시작해보세요!"
    }
    
    override func setupStyles() {        
        titleLabel.textColor = .white
        titleLabel.font = .setFont(.body1())
        
        subtitleLabel.textColor = .white
        subtitleLabel.font = .setFont(.caption1())
        
        stackView.axis = .vertical
        stackView.spacing = 13
        stackView.alignment = .center
        
        textStackView.axis = .vertical
        textStackView.spacing = 11
        textStackView.alignment = .center
    }
    
    override func setupLayouts() {
        stackView.ezl.makeConstraint {
            $0.center(to: self)
        }
    }
}
