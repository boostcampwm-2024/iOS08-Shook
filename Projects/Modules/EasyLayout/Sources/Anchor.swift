import UIKit

// MARK: - YAnchor

public struct YAnchor {
    enum Edge {
        case top(Anchorable)
        case bottom(Anchorable)

        var standard: NSLayoutYAxisAnchor {
            switch self {
            case let .top(view): view.topAnchor
            case let .bottom(view): view.bottomAnchor
            }
        }
    }

    let edge: Edge

    static func top(_ view: Anchorable) -> Self {
        YAnchor(edge: .top(view))
    }

    static func bottom(_ view: Anchorable) -> Self {
        YAnchor(edge: .bottom(view))
    }
}

// MARK: - XAnchor

public struct XAnchor {
    enum Edge {
        case leading(Anchorable)
        case trailing(Anchorable)

        var standard: NSLayoutXAxisAnchor {
            switch self {
            case let .leading(view): view.leadingAnchor
            case let .trailing(view): view.trailingAnchor
            }
        }
    }

    let edge: Edge

    static func leading(_ view: Anchorable) -> Self {
        XAnchor(edge: .leading(view))
    }

    static func trailing(_ view: Anchorable) -> Self {
        XAnchor(edge: .trailing(view))
    }
}
