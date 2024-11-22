import UIKit

import BaseFeature
import EasyLayoutModule

protocol ThumbnailViewContainer {
    var thumbnailView: ThumbnailView { get }
}

final class ThumbnailView: BaseView {
    enum Size {
        case large, small
    }
    
    enum Transition {
        case present, dismiss
    }
    
    let shadowView = UIView()
    let containerView = UIView()
    let imageView = UIImageView()
    
    var size: Size
    
    init(with size: Size) {
        self.size = size
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
        imageView.layer.cornerRadius = size == .large ? 16 : 8
    }
    
    override func setupLayouts() {
        containerView.ezl.makeConstraint {
            $0.diagonal(to: self)
        }
        
        imageView.ezl.makeConstraint {
            $0.horizontal(to: containerView, padding: 16)
                .vertical(to: containerView)
        }
        
        shadowView.ezl.makeConstraint {
            $0.diagonal(to: self)
        }
    }
    
    func updateStyles(for transition: Transition) {
        if transition == .present {
            imageView.layer.cornerRadius = 0
        }
    }
    
    func updateLayouts(for transition: Transition) {
        if transition == .present {
            imageView.ezl.makeConstraint {
                $0.diagonal(to: self)
            }
        } else {
            imageView.ezl.makeConstraint {
                $0.horizontal(to: containerView, padding: 16)
                    .vertical(to: containerView)
            }
        }
    }
    
    func configure(with image: UIImage?) {
        imageView.image = image
    }
}
