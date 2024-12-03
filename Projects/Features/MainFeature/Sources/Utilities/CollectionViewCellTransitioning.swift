import UIKit

final class CollectionViewCellTransitioning: NSObject {
    enum Transition {
        case present
        case dismiss
        
        var blurAlpha: CGFloat { return self == .present ? 1 : 0 }
        var dimmingAlpha: CGFloat { return self == .present ? 0.6 : 0 }
        var closeAlpha: CGFloat { return self == .present ? 1 : 0 }
        var cornerRadius: CGFloat { return self == .present ? 16 : 0 }
        var next: Transition { return self == .present ? .dismiss : .present }
    }
    
    var transition: Transition = .present
    
    let transitionDuration: Double = 1
    let shrinkDuration: Double = 0.2
    
    private let blurEffectView = UIVisualEffectView()
    private let backgroundView = UIView()
    
    override init() {
        super.init()
        blurEffectView.effect = UIBlurEffect(style: .dark)
        backgroundView.backgroundColor = .black
    }
}

// MARK: - UIViewControllerTransitioningDelegate

/// transition 속성을 변경하고 UIViewControllerAnimatedTransitioning를 채택한 자기 자신을 반환합니다.
extension CollectionViewCellTransitioning: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        transition = .present
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        transition = .dismiss
        return self
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension CollectionViewCellTransitioning: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        transitionDuration
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        containerView.subviews.forEach { $0.removeFromSuperview() }
        
        blurEffectView.frame = containerView.frame
        blurEffectView.alpha = transition.next.blurAlpha
        containerView.addSubview(blurEffectView)
        
        let fromView = transitionContext.viewController(forKey: .from)
        let toView = transitionContext.viewController(forKey: .to)
        
        var thumbnailView: ThumbnailView?
        if let navigationController = (fromView as? UINavigationController), let viewController = (navigationController.topViewController as? BroadcastCollectionViewController) {
            thumbnailView = viewController.selectedThumbnailView
        }
        
        if let navigationController = (toView as? UINavigationController), let viewController = (navigationController.topViewController as? BroadcastCollectionViewController) {
            thumbnailView = viewController.selectedThumbnailView
        }
        
        guard let thumbnailView else { return }
        let thumbnailViewCopy = copy(of: thumbnailView)
        containerView.addSubview(thumbnailViewCopy)
        thumbnailView.isHidden = true
        
        let absoluteFrame = thumbnailView.convert(thumbnailView.frame, to: nil)
        thumbnailViewCopy.frame = absoluteFrame
        thumbnailViewCopy.layoutIfNeeded()
        
        backgroundView.frame = transition == .present ? thumbnailViewCopy.imageView.frame : containerView.frame
        backgroundView.layer.cornerRadius = transition.cornerRadius
        thumbnailViewCopy.insertSubview(backgroundView, aboveSubview: thumbnailViewCopy.shadowView)
        
        if transition == .present, let toView {
            containerView.addSubview(toView.view)
            toView.view.isHidden = true
            moveAndConvert(thumbnailView: thumbnailViewCopy, containerView: containerView, to: absoluteFrame) {
                toView.view.isHidden = false
                thumbnailViewCopy.removeFromSuperview()
                thumbnailView.isHidden = false
                transitionContext.completeTransition(true)
            }
        }
        
        if transition == .dismiss, let fromView {
            fromView.view.isHidden = true

            thumbnailViewCopy.frame = CGRect(x: 0, y: fromView.view.layoutMargins.top, width: containerView.frame.width, height: containerView.frame.width * 0.5625)
            
            moveAndConvert(thumbnailView: thumbnailViewCopy, containerView: containerView, to: absoluteFrame) {
                thumbnailView.isHidden = false
                transitionContext.completeTransition(true)
            }
        }
    }
}

// MARK: - Methods
extension CollectionViewCellTransitioning {
    private func copy(of thumbnailView: ThumbnailView) -> ThumbnailView {
        let thumbnailViewCopy = ThumbnailView(with: thumbnailView.size)
        thumbnailViewCopy.configure(with: thumbnailView.imageView.image)
        return thumbnailViewCopy
    }
    
    private func makeShrinkAnimator(of thumbnailView: ThumbnailView) -> UIViewPropertyAnimator {
        UIViewPropertyAnimator(duration: shrinkDuration, curve: .linear) {
            thumbnailView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    private func makeExpandContractAnimator(of thumbnailView: ThumbnailView, in containerView: UIView, to frame: CGRect) -> UIViewPropertyAnimator {
        let springTiming = UISpringTimingParameters(dampingRatio: 0.75, initialVelocity: CGVector(dx: 0, dy: 2))
        let animator = UIViewPropertyAnimator(duration: transitionDuration - shrinkDuration, timingParameters: springTiming)
        
        animator.addAnimations {
            thumbnailView.transform = .identity
            
            if self.transition == .present {
                thumbnailView.updateStyles(for: .present)
                thumbnailView.updateLayouts(for: .present)
                thumbnailView.frame = CGRect(x: 0, y: containerView.layoutMargins.top, width: containerView.frame.width, height: containerView.frame.width * 0.5625)
            } else {
                thumbnailView.updateStyles(for: .dismiss)
                thumbnailView.updateLayouts(for: .dismiss)
                thumbnailView.frame = frame
            }
            
            self.blurEffectView.alpha = self.transition.blurAlpha
            
            self.backgroundView.layer.cornerRadius = self.transition.next.cornerRadius
            self.backgroundView.frame = containerView.frame
            
            containerView.layoutIfNeeded()
            
            self.backgroundView.frame = self.transition == .present ? containerView.frame : thumbnailView.imageView.frame
        }
        
        return animator
    }
    
    private func moveAndConvert(thumbnailView: ThumbnailView, containerView: UIView, to frame: CGRect, completion: @escaping () -> Void) {
        let shrinkAnimator = makeShrinkAnimator(of: thumbnailView)
        let expandContractAnimator = makeExpandContractAnimator(of: thumbnailView, in: containerView, to: frame)
        
        expandContractAnimator.addCompletion { _ in
            completion()
        }
        
        if transition == .present {
            shrinkAnimator.addCompletion { _ in
                thumbnailView.layoutIfNeeded()
                expandContractAnimator.startAnimation()
            }
            
            shrinkAnimator.startAnimation()
        } else {
            thumbnailView.layoutIfNeeded()
            expandContractAnimator.startAnimation()
        }
    }
}
