import UIKit

// MARK: YAnchor
public enum YAnchor {
    case top(UIView)
    case bottom(UIView)
    
    var standard: NSLayoutYAxisAnchor {
        switch self {
        case .top(let view): view.topAnchor
        case .bottom(let view): view.bottomAnchor
        }
    }
}

// MARK: XAnchor
public enum XAnchor {
    case leading(UIView)
    case trailing(UIView)
    
    var standard: NSLayoutXAxisAnchor {
        switch self {
        case .leading(let view): view.leadingAnchor
        case .trailing(let view): view.trailingAnchor
        }
    }
}
