import UIKit

public struct EasyConstraint {
    private let view: UIView
    
    init(_ view: UIView) {
        self.view = view
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @discardableResult
    public func width(_ width: CGFloat) -> Self {
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        return self
    }
}
