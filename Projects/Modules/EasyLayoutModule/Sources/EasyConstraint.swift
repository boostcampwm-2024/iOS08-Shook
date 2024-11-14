import UIKit

public struct EasyConstraint {
    let baseView: UIView
    
    init(_ baseView: UIView) {
        self.baseView = baseView
        baseView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @discardableResult
    public func width(_ width: CGFloat) -> Self {
        baseView.widthAnchor.constraint(equalToConstant: width).isActive = true
        return self
    }
    
    @discardableResult
    public func height(_ height: CGFloat) -> Self {
        baseView.heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    @discardableResult
    public func size(with size: CGFloat) -> Self {
        width(size).height(size)
    }
    
    @discardableResult
    public func top(to anchor: YAnchor) -> Self {
        baseView.topAnchor.constraint(equalTo: anchor.standard).isActive = true
        return self
    }
    
    @discardableResult
    public func bottom(to anchor: YAnchor) -> Self {
        baseView.bottomAnchor.constraint(equalTo: anchor.standard).isActive = true
        return self
    }
    
    @discardableResult
    public func leading(to anchor: XAnchor) -> Self {
        baseView.leadingAnchor.constraint(equalTo: anchor.standard).isActive = true
        return self
    }
    
    @discardableResult
    public func trailing(to anchor: XAnchor) -> Self {
        baseView.trailingAnchor.constraint(equalTo: anchor.standard).isActive = true
        return self
    }
    
    @discardableResult
    public func horizontal(to view: UIView) -> Self {
        leading(to: view.ezl.leading).trailing(to: view.ezl.trailing)
    }
    
    @discardableResult
    public func vertical(to view: UIView) -> Self {
        top(to: view.ezl.top).bottom(to: view.ezl.bottom)
    }
}
