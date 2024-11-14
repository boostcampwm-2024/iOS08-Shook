import UIKit

public struct EasyConstraint {
    let baseView: Anchorable
    
    init(_ baseView: Anchorable) {
        self.baseView = baseView
        guard let view = baseView as? UIView else { return }
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: About Size
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
    
    // MARK: About Position
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
    public func horizontal(to view: Anchorable) -> Self {
        leading(to: view.ezl.leading).trailing(to: view.ezl.trailing)
    }
    
    @discardableResult
    public func vertical(to view: Anchorable) -> Self {
        top(to: view.ezl.top).bottom(to: view.ezl.bottom)
    }
    
    @discardableResult
    public func diagonal(to view: Anchorable) -> Self {
        top(to: view.ezl.top).bottom(to: view.ezl.bottom).leading(to: view.ezl.leading).trailing(to: view.ezl.trailing)
    }
    
    // MARK: About Center
    @discardableResult
    public func centerX(to view: Anchorable) -> Self {
        baseView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        return self
    }
    
    @discardableResult
    public func centerY(to view: Anchorable) -> Self {
        baseView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return self
    }
}
