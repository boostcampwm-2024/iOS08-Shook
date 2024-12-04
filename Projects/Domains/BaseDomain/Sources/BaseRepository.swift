import Combine
import Foundation

import FastNetwork

// MARK: - BaseRepository

open class BaseRepository<E: Endpoint> {
    private let decoder: JSONDecoder = .init()
    private let client: NetworkClient<E>

    public init() {
        var interceptors: [any Interceptor] = []
        #if DEBUG
            interceptors.append(DefaultLoggingInterceptor())
        #endif
        client = NetworkClient(interceptors: interceptors)
    }

    public final func request<T>(_ endpoint: E, type: T.Type) -> AnyPublisher<T, Error> where T: Decodable {
        performRequest(endpoint)
            .map(\.data)
            .decode(type: type, decoder: decoder)
            .eraseToAnyPublisher()
    }
}

private extension BaseRepository {
    @discardableResult
    final func performRequest(_ endpoint: E) -> AnyPublisher<Response, Error> {
        Deferred {
            Future<Response, Error> { [weak self] promise in
                guard let self else { return }
                Task(priority: .background) {
                    do {
                        let result = try await self.client.request(endpoint)
                        promise(.success(result))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
