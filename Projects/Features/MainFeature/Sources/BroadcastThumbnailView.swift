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
        addSubview(imageView)
    }
    
    override func setupStyles() {
        shadowView.backgroundColor = .systemBackground

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = size == .large ? 16 : 8
    }
    
    override func setupLayouts() {
        imageView.ezl.makeConstraint {
            $0.horizontal(to: self, padding: 16)
                .vertical(to: self)
        }
        
        shadowView.ezl.makeConstraint {
            $0.diagonal(to: self)
        }
    }
    
    func updateStyles(for transition: Transition) {
        if transition == .present {
            imageView.layer.cornerRadius = 0
        } else {
            imageView.layer.cornerRadius = size == .large ? 16 : 8
        }
    }
    
    func updateLayouts(for transition: Transition) {
        removeImageViewConstraints()
        
        if transition == .present {
            imageView.ezl.makeConstraint {
                $0.diagonal(to: self)
            }
        } else {
            imageView.ezl.makeConstraint {
                $0.horizontal(to: self, padding: 16)
                    .vertical(to: self)
            }
        }
    }
    
    func configure(with image: UIImage?) {
        imageView.image = image
    }
    
    private func removeImageViewConstraints() {
        if let superview = imageView.superview {
            superview.constraints.forEach {
                if $0.firstItem as? UIView == imageView || $0.secondItem as? UIView == imageView {
                    superview.removeConstraint($0)
                }
            }
        }
    }
}
