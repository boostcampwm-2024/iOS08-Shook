import Foundation

// MARK: - WebSocketError

enum WebSocketError: Error {
    case invalidURL
}

// MARK: - WebSocket

public final class WebSocket: NSObject {
    public static let shared = WebSocket()

    var url: URL?
    var onReceiveClosure: ((ChatMessage?) -> Void)?
    weak var delegate: URLSessionWebSocketDelegate?

    private var webSocketTask: URLSessionWebSocketTask? {
        didSet { oldValue?.cancel(with: .goingAway, reason: nil) }
    }

    private var timer: Timer?
    private let encoder: JSONEncoder = .init()
    private let decoder: JSONDecoder = .init()

    override private init() {}

    public func openWebSocket() throws {
        url = URL(string: "ws:/\(host):\(port)/ws/chat")
        guard let url else { throw WebSocketError.invalidURL }

        let urlSession = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: OperationQueue()
        )
        let webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask.resume()

        self.webSocketTask = webSocketTask

        startPing()
    }

    public func send(data: ChatMessage) {
        guard let data = try? encoder.encode(data) else { return }

        let taskMessage = URLSessionWebSocketTask.Message.data(data)

        webSocketTask?.send(taskMessage) { error in
            guard error != nil else { return }
        }
    }

    public func closeWebSocket() {
        timer?.invalidate()
        onReceiveClosure = nil
        delegate = nil
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
    }

    public func receive(onReceive: @escaping ((ChatMessage?) -> Void)) {
        onReceiveClosure = onReceive
        webSocketTask?.receive { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(message):
                switch message {
                case let .string(string):
                    guard let data = string.data(using: .utf8) else {
                        onReceive(nil)
                        return
                    }
                    let message = try? decoder.decode(ChatMessage.self, from: data)
                    onReceive(message)

                case let .data(data):
                    let message = try? decoder.decode(ChatMessage.self, from: data)
                    onReceive(message)

                @unknown default:
                    onReceive(nil)
                }

            case .failure:
                closeWebSocket()
            }
            receive(onReceive: onReceive)
        }
    }

    private func startPing() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            withTimeInterval: 10,
            repeats: true
        ) { [weak self] _ in
            self?.ping()
        }
    }

    private func ping() {
        webSocketTask?.sendPing { [weak self] error in
            guard error != nil else { return }
            self?.startPing()
        }
    }
}

// MARK: URLSessionWebSocketDelegate

extension WebSocket: URLSessionWebSocketDelegate {
    public func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?
    ) {
        delegate?.urlSession?(
            session,
            webSocketTask: webSocketTask,
            didOpenWithProtocol: `protocol`
        )
    }

    public func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
    ) {
        delegate?.urlSession?(
            session,
            webSocketTask: webSocketTask,
            didCloseWith: closeCode,
            reason: reason
        )
    }
}

extension WebSocket {
    func config(key: String) -> String {
        guard let secrets = Bundle.main.object(forInfoDictionaryKey: "SECRETS") as? [String: Any] else {
            return ""
        }
        return secrets[key] as? String ?? "not found key"
    }

    var host: String {
        config(key: "HOST")
    }

    var port: String {
        config(key: "PORT")
    }
}
