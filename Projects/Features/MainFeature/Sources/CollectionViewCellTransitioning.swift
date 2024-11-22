import UIKit

final class CollectionViewCellTransitioning: NSObject {
    enum Transition {
        case present
        case dismiss
        
        var blurAlpha: CGFloat { return self == .present ? 1 : 0 }
        var dimAlpha: CGFloat { return self == .present ? 0.2 : 0 }
        var closeAlpha: CGFloat { return self == .present ? 1 : 0 }
        var cornerRadius: CGFloat { return self == .present ? 20.0 : 0.0 }
        var next: Transition { return self == .present ? .dismiss : .present }
    }
    
    var transition: Transition = .present
    var transitionDuration: Double = 1.0
    let shrinkDuration: Double = 0.2
    
    private let blurEffectView = UIVisualEffectView()
    private let dimmingView = UIView()
    private let backgroundView = UIView()
    
    override init() {
        super.init()
        blurEffectView.effect = UIBlurEffect(style: .dark)
        dimmingView.backgroundColor = .black
        backgroundView.backgroundColor = .systemBackground
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
        
        addBackgroundViews(to: containerView)
        
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
        
        backgroundView.frame = transition == .present ? thumbnailViewCopy.containerView.frame : containerView.frame
        backgroundView.layer.cornerRadius = transition.cornerRadius
        thumbnailViewCopy.insertSubview(backgroundView, aboveSubview: thumbnailViewCopy.shadowView)
        
        if transition == .present, let toView {
            containerView.addSubview(toView.view)
            toView.view.isHidden = true
            moveAndConvert(thumbnailView: thumbnailViewCopy, containerView: containerView, to: containerView.layoutMargins.top) {
                toView.view.isHidden = false
                thumbnailViewCopy.removeFromSuperview()
                thumbnailView.isHidden = false
                transitionContext.completeTransition(true)
            }
        }
        
        if transition == .dismiss, let fromView {
            fromView.view.isHidden = true

            thumbnailViewCopy.frame = CGRect(x: 0, y: fromView.view.layoutMargins.top, width: fromView.view.frame.width, height: fromView.view.frame.width * 0.5625)
            thumbnailViewCopy.layoutIfNeeded()
            
            moveAndConvert(thumbnailView: thumbnailViewCopy, containerView: containerView, to: absoluteFrame.origin.y) {
                thumbnailView.isHidden = false
                transitionContext.completeTransition(true)
            }
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate
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

// MARK: - Methods
extension CollectionViewCellTransitioning {
    private func addBackgroundViews(to containerView: UIView) {
        blurEffectView.frame = containerView.frame
        blurEffectView.alpha = transition.next.blurAlpha
        containerView.addSubview(blurEffectView)
        
        dimmingView.frame = containerView.frame
        dimmingView.alpha = transition.next.dimAlpha
        containerView.addSubview(dimmingView)
    }
    
    private func copy(of thumbnailView: ThumbnailView) -> ThumbnailView {
        let thumbnailViewCopy = ThumbnailView(for: thumbnailView.size)
        thumbnailViewCopy.configure(with: thumbnailView.imageView.image)
        return thumbnailViewCopy
    }
    
    private func makeShrinkAnimator(of thumbnailView: ThumbnailView) -> UIViewPropertyAnimator {
        UIViewPropertyAnimator(duration: shrinkDuration, curve: .linear) {
            thumbnailView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.dimmingView.alpha = 0.8
        }
    }
    
    private func makeExpandContractAnimator(of thumbnailView: ThumbnailView, in containerView: UIView, yOrigin: CGFloat) -> UIViewPropertyAnimator {
        let springTiming = UISpringTimingParameters(dampingRatio: 0.75, initialVelocity: CGVector(dx: 0, dy: 4))
        let animator = UIViewPropertyAnimator(duration: transitionDuration - shrinkDuration, timingParameters: springTiming)
        
        animator.addAnimations {
            thumbnailView.transform = .identity
            thumbnailView.containerView.layer.cornerRadius = self.transition.next.cornerRadius
            thumbnailView.frame.origin.y = yOrigin
            
            if self.transition == .present {
                thumbnailView.updateStyles(for: .present)
                thumbnailView.updateLayouts(for: .present)
            } else {
                thumbnailView.updateStyles(for: .dismiss)
            }
            
            self.blurEffectView.alpha = self.transition.blurAlpha
            self.dimmingView.alpha = self.transition.dimAlpha
            
            self.backgroundView.layer.cornerRadius = self.transition.next.cornerRadius
            self.backgroundView.frame = containerView.frame
            
            containerView.layoutIfNeeded()
            
            self.backgroundView.frame = self.transition == .present ? containerView.frame : thumbnailView.containerView.frame
        }
        
        return animator
    }
    
    private func moveAndConvert(thumbnailView: ThumbnailView, containerView: UIView, to yOrigin: CGFloat, completion: @escaping () -> Void) {
        let shrinkAnimator = makeShrinkAnimator(of: thumbnailView)
        let expandContractAnimator = makeExpandContractAnimator(of: thumbnailView, in: containerView, yOrigin: yOrigin)
        
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
