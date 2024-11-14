public struct EasyLayout {
    private let constraint: EasyConstraint
    
    init(_ constraint: EasyConstraint) {
        self.constraint = constraint
    }
    
    public func makeConstraint(handler: (EasyConstraint) -> Void) {
        handler(constraint)
    }
    
    public var top: YAnchor {
        .top(constraint.view)
    }
    
    public var bottom: YAnchor {
        .bottom(constraint.view)
    }
    
    public var leading: XAnchor {
        .leading(constraint.view)
    }
    
    public var trailing: XAnchor {
        .trailing(constraint.view)
    }
}
