import UIKit

// MARK: YAnchor
public enum YAnchor {
    case top(of: UIView)
    case bottom(of: UIView)
    
    var standard: NSLayoutYAxisAnchor {
        switch self {
        case .top(let view): view.topAnchor
        case .bottom(let view): view.bottomAnchor
        }
    }
}

// MARK: XAnchor
public enum XAnchor {
    case leading(of: UIView)
    case trailing(of: UIView)
    
    var standard: NSLayoutXAxisAnchor {
        switch self {
        case .leading(let view): view.leadingAnchor
        case .trailing(let view): view.trailingAnchor
        }
    }
}
