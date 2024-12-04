import UIKit

import BaseFeature
import EasyLayout

// MARK: - ThumbnailViewContainer

protocol ThumbnailViewContainer {
    var thumbnailView: ThumbnailView { get }
}

// MARK: - ThumbnailView

final class ThumbnailView: BaseView {
    enum Size {
        case large
        case small
    }

    enum Transition {
        case present
        case dismiss
    }

    let shadowView = UIView()
    let imageView = UIImageView()

    var size: Size

    init(with size: Size) {
        self.size = size
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupViews() {
        addSubview(shadowView)
        addSubview(imageView)
    }

    override func setupStyles() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = size == .large ? 16 : 12
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
            imageView.layer.cornerRadius = size == .large ? 16 : 12
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

    func configure(with imageURLString: String) {
        guard let url = URL(string: imageURLString) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data else { return }
            DispatchQueue.main.async {
                self?.imageView.image = UIImage(data: data)
            }
        }.resume()
    }

    func configure(with image: UIImage?) {
        imageView.image = image
    }

    private func removeImageViewConstraints() {
        if let superview = imageView.superview {
            for constraint in superview.constraints {
                if constraint.firstItem as? UIView == imageView || constraint.secondItem as? UIView == imageView {
                    superview.removeConstraint(constraint)
                }
            }
        }
    }
}
