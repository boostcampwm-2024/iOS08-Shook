import Foundation

final class DIContainer {
    static let shared = DIContainer()

    private var dependencies: [String: Any] = [:]

    private init() {}

    func register<T>(_ type: T.Type, dependency: T) {
        let key = String(describing: type)
        dependencies[key] = dependency
    }

    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        guard let dependency = dependencies[key] as? T else {
            fatalError("No registered factory for \(key)")
        }
        return dependency
    }
}
