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
    public func top(to anchor: YAnchor, offset: CGFloat = 0) -> Self {
        baseView.topAnchor.constraint(
            equalTo: anchor.edge.standard,
            constant: offset
        ).isActive = true
        return self
    }
    
    @discardableResult
    public func bottom(to anchor: YAnchor, offset: CGFloat = 0) -> Self {
        baseView.bottomAnchor.constraint(
            equalTo: anchor.edge.standard,
            constant: offset
        ).isActive = true
        return self
    }
    
    @discardableResult
    public func leading(to anchor: XAnchor, offset: CGFloat = 0) -> Self {
        baseView.leadingAnchor.constraint(
            equalTo: anchor.edge.standard,
            constant: offset
        ).isActive = true
        return self
    }
    
    @discardableResult
    public func trailing(to anchor: XAnchor, offset: CGFloat = 0) -> Self {
        baseView.trailingAnchor.constraint(
            equalTo: anchor.edge.standard,
            constant: offset
        ).isActive = true
        return self
    }
    
    @discardableResult
    public func horizontal(to view: Anchorable, padding: CGFloat = 0.0) -> Self {
        leading(to: view.ezl.leading, offset: padding)
            .trailing(to: view.ezl.trailing, offset: padding * -1)
    }
    
    @discardableResult
    public func vertical(to view: Anchorable, padding: CGFloat = 0.0) -> Self {
        top(to: view.ezl.top, offset: padding)
            .bottom(to: view.ezl.bottom, offset: padding * -1)
    }
    
    @discardableResult
    public func diagonal(to view: Anchorable, padding: CGFloat = 0.0) -> Self {
        horizontal(to: view, padding: padding)
            .vertical(to: view, padding: padding)
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
    
    @discardableResult
    public func center(to view: Anchorable) -> Self {
        centerX(to: view).centerY(to: view)
    }
}
