import UIKit

// MARK: YAnchor
public enum YAnchor {
    case top(Anchorable)
    case bottom(Anchorable)
    
    var standard: NSLayoutYAxisAnchor {
        switch self {
        case let .top(view): view.topAnchor
        case let .bottom(view): view.bottomAnchor
        }
    }
}

// MARK: XAnchor
public enum XAnchor {
    case leading(Anchorable)
    case trailing(Anchorable)
    
    var standard: NSLayoutXAxisAnchor {
        switch self {
        case let .leading(view): view.leadingAnchor
        case let .trailing(view): view.trailingAnchor
        }
    }
}
