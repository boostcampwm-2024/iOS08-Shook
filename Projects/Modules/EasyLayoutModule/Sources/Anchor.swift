import UIKit

// MARK: YAnchor
public enum YAnchor {
    case top(Anchorable)
    case bottom(Anchorable)
    
    var standard: NSLayoutYAxisAnchor {
        switch self {
        case .top(let view): view.topAnchor
        case .bottom(let view): view.bottomAnchor
        }
    }
}

// MARK: XAnchor
public enum XAnchor {
    case leading(Anchorable)
    case trailing(Anchorable)
    
    var standard: NSLayoutXAxisAnchor {
        switch self {
        case .leading(let view): view.leadingAnchor
        case .trailing(let view): view.trailingAnchor
        }
    }
}
