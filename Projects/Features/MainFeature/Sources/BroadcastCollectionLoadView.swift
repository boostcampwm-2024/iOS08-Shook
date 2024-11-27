import UIKit

import BaseFeature
import DesignSystem

final class BroadcastCollectionLoadView: BaseView {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private lazy var textStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
    
    override func setupViews() {
        addSubview(textStackView)
        
        titleLabel.text = "방송을 불러오는 중이에요!"
        
        subtitleLabel.text = "잠시만 기다려주세요!"
    }
    
    override func setupStyles() {
        titleLabel.textColor = .white
        titleLabel.font = .setFont(.title())
        
        subtitleLabel.textColor = .gray
        subtitleLabel.font = .setFont(.body2())
        
        textStackView.axis = .vertical
        textStackView.spacing = 12
    }
    
    override func setupLayouts() {
        textStackView.ezl.makeConstraint {
            $0.center(to: self)
        }
    }
}
