import UIKit

// MARK: - CollectionViewCellTransitioning

final class CollectionViewCellTransitioning: NSObject {
    enum Transition {
        case present
        case dismiss

        var blurAlpha: CGFloat { self == .present ? 1 : 0 }
        var dimmingAlpha: CGFloat { self == .present ? 0.6 : 0 }
        var closeAlpha: CGFloat { self == .present ? 1 : 0 }
        var cornerRadius: CGFloat { self == .present ? 16 : 0 }
        var next: Transition { self == .present ? .dismiss : .present }
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

// MARK: UIViewControllerTransitioningDelegate

/// transition 속성을 변경하고 UIViewControllerAnimatedTransitioning를 채택한 자기 자신을 반환합니다.
extension CollectionViewCellTransitioning: UIViewControllerTransitioningDelegate {
    func animationController(forPresented _: UIViewController, presenting _: UIViewController, source _: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        transition = .present
        return self
    }

    func animationController(forDismissed _: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        transition = .dismiss
        return self
    }
}

// MARK: UIViewControllerAnimatedTransitioning

extension CollectionViewCellTransitioning: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using _: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        transitionDuration
    }

    /// 실제 Transition 구현 부분
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        /// 전환에 관련된 뷰를 사용합니다.
        let containerView = transitionContext.containerView
        /// 1. 깔끔한 애니메이션을 위해 transition되는 containerView의 모든 요소를 제거합니다.
        containerView.subviews.forEach { $0.removeFromSuperview() }

        /// 2. 전환에 사용되는 뷰에 blurEffectView 추가합니다.
        blurEffectView.frame = containerView.frame
        blurEffectView.alpha = transition.next.blurAlpha
        containerView.addSubview(blurEffectView)

        let fromView = transitionContext.viewController(forKey: .from)
        let toView = transitionContext.viewController(forKey: .to)

        var thumbnailView: ThumbnailView?
        /// 3. Present: 시작하는 뷰의 썸네일을 가져옵니다. (시작 좌표 및 복사를 위해)
        if let navigationController = (fromView as? UINavigationController), let viewController = (navigationController.topViewController as? BroadcastCollectionViewController) {
            thumbnailView = viewController.selectedThumbnailView
        }

        /// 3. Dismiss: 목적지 뷰의 썸네일을 가져옵니다. (도착 좌표 및 복사를 위해)
        if let navigationController = (toView as? UINavigationController), let viewController = (navigationController.topViewController as? BroadcastCollectionViewController) {
            thumbnailView = viewController.selectedThumbnailView
        }

        /// 4. 썸네일 뷰를 복사하고 절대 프레임을 가져옵니다.
        guard let thumbnailView else { return }
        let thumbnailViewCopy = copy(of: thumbnailView)
        let absoluteFrame = thumbnailView.convert(thumbnailView.frame, to: nil)

        /// 애니메이션의 디테일을 위한 설정
        backgroundView.frame = transition == .present ? absoluteFrame : containerView.frame
        backgroundView.layer.cornerRadius = transition.cornerRadius
        thumbnailViewCopy.insertSubview(backgroundView, aboveSubview: thumbnailViewCopy.shadowView)

        /// 5. 기존 썸네일을 숨기고 복사한 썸네일을 containerView에 추가합니다.
        containerView.addSubview(thumbnailViewCopy)
        thumbnailView.isHidden = true

        /// 6. Present: 애니메이션, 작았다 커지면서 위로 이동합니다.
        if transition == .present, let toView {
            /// 6-1. 썸네일은 원래 위치에서 시작
            thumbnailViewCopy.frame = absoluteFrame
            /// 6-2. containerView에 띄워줄 뷰 추가 후 숨김
            containerView.addSubview(toView.view)
            toView.view.isHidden = true
            /// 6-3. 애니메이션
            moveAndConvert(thumbnailView: thumbnailViewCopy, containerView: containerView, to: absoluteFrame) {
                /// 6-4. 띄워줄 뷰 표시
                toView.view.isHidden = false
                /// 6-5. 썸네일 복사 뷰 제거, 썸네일 뷰 원상복구 (표시)
                thumbnailViewCopy.removeFromSuperview()
                thumbnailView.isHidden = false
                /// 6-6. 애니메이션 종료 알림
                transitionContext.completeTransition(true)
            }
        }

        /// 6. Dismiss: 위에서 셀의 위치로 돌아오면서 작아집니다.
        if transition == .dismiss, let fromView {
            /// 6-1. 시작 뷰 숨김
            fromView.view.isHidden = true
            /// 6-2. 썸네일 복사 뷰 위치를 시작하는 플레이어 위치부터 시작
            thumbnailViewCopy.frame = CGRect(x: 0, y: fromView.view.layoutMargins.top, width: containerView.frame.width, height: containerView.frame.width * 0.5625)
            /// 6-3. 애니메이션
            moveAndConvert(thumbnailView: thumbnailViewCopy, containerView: containerView, to: absoluteFrame) {
                /// 6-4. 썸네일 복사 뷰 제거, 썸네일 뷰 원상복구 (표시)
                thumbnailViewCopy.removeFromSuperview()
                thumbnailView.isHidden = false
                /// 6-6. 애니메이션 종료 알림
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

    /// Present 때 사용되는 애니메이션
    /// 썸네일을 잠깐 축소했다가 확대시키면서 애니메이션이 진행됩니다.
    private func makeShrinkAnimator(of thumbnailView: ThumbnailView) -> UIViewPropertyAnimator {
        UIViewPropertyAnimator(duration: shrinkDuration, curve: .linear) {
            thumbnailView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }

    /// Present, Dismiss 때 사용되는 애니메이션
    private func makeScaleAndPositionAnimator(of thumbnailView: ThumbnailView, in containerView: UIView, to frame: CGRect) -> UIViewPropertyAnimator {
        /// 애니메이션 설정
        let springTiming = UISpringTimingParameters(dampingRatio: 0.75, initialVelocity: CGVector(dx: 0, dy: 2))
        let animator = UIViewPropertyAnimator(duration: transitionDuration - shrinkDuration, timingParameters: springTiming)

        animator.addAnimations {
            switch self.transition {
            case .present:
                /// 작아졌던 썸네일 뷰 원상태로
                thumbnailView.transform = .identity
                /// 썸네일 뷰 Style, Layout 업데이트
                thumbnailView.updateStyles(for: .present)
                thumbnailView.updateLayouts(for: .present)
                /// 썸네일 뷰 플레이어뷰 위치로 이동 및 확대
                thumbnailView.frame = CGRect(x: 0, y: containerView.layoutMargins.top, width: containerView.frame.width, height: containerView.frame.width * 0.5625)

            case .dismiss:
                /// 썸네일 뷰 Style, Layout 업데이트
                thumbnailView.updateStyles(for: .dismiss)
                thumbnailView.updateLayouts(for: .dismiss)
                /// 인자로 받은 frame위치로 이동 (기존 썸네일 뷰의 절대 프레임)
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
        let scaleAndPositionAnimator = makeScaleAndPositionAnimator(of: thumbnailView, in: containerView, to: frame)

        switch transition {
        case .present:
            shrinkAnimator.startAnimation()

            /// 축소 애니메이션 종료 후 확대 애니메이션
            shrinkAnimator.addCompletion { _ in
                scaleAndPositionAnimator.startAnimation()
            }

        case .dismiss:
            /// 썸네일 뷰의 위치를 먼저 잡고 축소 애니메이션
            thumbnailView.layoutIfNeeded()
            scaleAndPositionAnimator.startAnimation()
        }

        /// 크기, 위치 애니메이션 종료 후
        scaleAndPositionAnimator.addCompletion { _ in
            completion()
        }
    }
}
