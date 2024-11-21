import UIKit

import BaseFeature
import EasyLayoutModule

protocol ThumbnailViewContainer {
    var thumbnailView: ThumbnailView { get }
}

final class ThumbnailView: BaseView {
    enum ViewMode {
        case large, small, full
    }
    
    let shadowView = UIView()
    let containerView = UIView()
    let imageView = UIImageView()
    
    var viewMode: ViewMode
    
    init(for viewMode: ViewMode) {
        self.viewMode = viewMode
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        addSubview(shadowView)
        addSubview(containerView)
        
        containerView.addSubview(imageView)
    }
    
    override func setupStyles() {
        shadowView.backgroundColor = .systemBackground
        containerView.backgroundColor = .systemBackground
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = viewMode == .large ? 16 : 8
    }
    
    override func setupLayouts() {
        shadowView.ezl.makeConstraint {
            $0.diagonal(to: self)
        }
        
        containerView.ezl.makeConstraint {
            $0.diagonal(to: self)
        }
        
        imageView.ezl.makeConstraint {
            $0.diagonal(to: containerView)
        }
    }
    
    override func updateStyles() {
        
    }
    
    override func updateLayouts() {
        
    }
    
    func configure(with image: UIImage?) {
        imageView.image = image
    }
}
