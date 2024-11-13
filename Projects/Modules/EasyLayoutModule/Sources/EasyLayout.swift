public struct EasyLayout {
    private let constraint: EasyConstraint
    
    init(_ constraint: EasyConstraint) {
        self.constraint = constraint
    }
    
    public func makeConstraint(handler: (EasyConstraint) -> Void) {
        handler(constraint)
    }
}
