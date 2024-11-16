import UIKit

// MARK: YAnchor
public struct YAnchor {
    enum `Type` {
        case top(Anchorable)
        case bottom(Anchorable)
        
        var standard: NSLayoutYAxisAnchor {
            switch self {
            case let .top(view): view.topAnchor
            case let .bottom(view): view.bottomAnchor
            }
        }
    }
    
    let type: `Type`
    
    static func top(_ view: Anchorable) -> Self {
        YAnchor(type: .top(view))
    }
    
    static func bottom(_ view: Anchorable) -> Self {
        YAnchor(type: .bottom(view))
    }
}

// MARK: XAnchor
public struct XAnchor {
    enum `Type` {
        case leading(Anchorable)
        case trailing(Anchorable)
        
        var standard: NSLayoutXAxisAnchor {
            switch self {
            case let .leading(view): view.leadingAnchor
            case let .trailing(view): view.trailingAnchor
            }
        }
    }
    
    let type: `Type`
    
    static func leading(_ view: Anchorable) -> Self {
        XAnchor(type: .leading(view))
    }
    
    static func trailing(_ view: Anchorable) -> Self {
        XAnchor(type: .trailing(view))
    }
}
