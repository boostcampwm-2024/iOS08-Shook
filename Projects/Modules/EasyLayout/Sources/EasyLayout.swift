public struct EasyLayout {
    private let constraint: EasyConstraint

    init(_ constraint: EasyConstraint) {
        self.constraint = constraint
    }

    public func makeConstraint(handler: (EasyConstraint) -> Void) {
        handler(constraint)
    }

    public var top: YAnchor {
        .top(constraint.baseView)
    }

    public var bottom: YAnchor {
        .bottom(constraint.baseView)
    }

    public var leading: XAnchor {
        .leading(constraint.baseView)
    }

    public var trailing: XAnchor {
        .trailing(constraint.baseView)
    }
}
