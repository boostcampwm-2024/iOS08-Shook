protocol Configurable {
    func with(_ block: (inout Self) throws -> Void) rethrows -> Self
}

extension Configurable {
    @inlinable // 클로저를 이용하여 configure 진행
    func with(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try block(&copy)
        return copy
    }
}
