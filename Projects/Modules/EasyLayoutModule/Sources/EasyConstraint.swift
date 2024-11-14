import UIKit

public struct EasyConstraint {
    let view: UIView
    
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
    
    @discardableResult
    public func top(to anchor: YAnchor) -> Self {
        view.topAnchor.constraint(equalTo: anchor.standard).isActive = true
        return self
    }
    
    @discardableResult
    public func bottom(to anchor: YAnchor) -> Self {
        view.bottomAnchor.constraint(equalTo: anchor.standard).isActive = true
        return self
    }
    
    @discardableResult
    public func leading(to anchor: XAnchor) -> Self {
        view.leadingAnchor.constraint(equalTo: anchor.standard).isActive = true
        return self
    }
    
    @discardableResult
    public func trailing(to anchor: XAnchor) -> Self {
        view.trailingAnchor.constraint(equalTo: anchor.standard).isActive = true
        return self
    }
}
