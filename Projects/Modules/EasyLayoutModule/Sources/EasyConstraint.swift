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
    
    @discardableResult
    public func height(_ height: CGFloat) -> Self {
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    @discardableResult
    public func size(with size: CGFloat) -> Self {
        width(size).height(size)
    }
}
