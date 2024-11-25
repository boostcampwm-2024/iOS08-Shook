import Foundation

enum WebSocketError: Error {
    case invalidURL
}

final class WebSocket: NSObject {
    static let shared = WebSocket()
    
    var url: URL?
    var onReceiveClosure: ((ChatMessage?) -> Void)?
    weak var delegate: URLSessionWebSocketDelegate?
    
    private var webSocketTask: URLSessionWebSocketTask? {
        didSet { oldValue?.cancel(with: .goingAway, reason: nil) }
    }
    
    private var timer: Timer?
    private let encoder: JSONEncoder = .init()
    private let decoder: JSONDecoder = .init()
    
    private override init() {}
    
    func openWebSocket() throws {
        guard let url = url else { throw WebSocketError.invalidURL }
        
        let urlSession = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: OperationQueue()
        )
        let webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask.resume()
        
        self.webSocketTask = webSocketTask
        
        self.startPing()
        
    }

    func send(data: ChatMessage) {
        guard let data = try? encoder.encode(data) else { return }
        
        let taskMessage = URLSessionWebSocketTask.Message.data(data)
        print("Send message \(taskMessage)")
        self.webSocketTask?.send(taskMessage, completionHandler: { error in
            guard let error = error else { return }
            print("WebSOcket sending error: \(error)")
        })
    }
    
    func closeWebSocket() {
        self.webSocketTask = nil
        self.timer?.invalidate()
        self.onReceiveClosure = nil
        self.delegate = nil
        self.webSocketTask?.cancel(with: .goingAway, reason: nil)
        self.webSocketTask = nil
    }
    
    func receive(onReceive: @escaping ((ChatMessage?) -> Void)) {
        self.onReceiveClosure = onReceive
        self.webSocketTask?.receive(completionHandler: { [weak self] result in
            print("Receive \(result)")
            guard let self else { return }
            switch result {
            case let .success(message):
                switch message {
                case let .string(string):
                    onReceive(nil)
                    
                case let .data(data):
                    let message = try? decoder.decode(ChatMessage.self, from: data)
                    onReceive(message)
                    
                @unknown default:
                    onReceive(nil)
                }
            case let .failure(error):
                self.closeWebSocket()
            }
            receive(onReceive: onReceive)
        })
    }
    
    private func startPing() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(
            withTimeInterval: 10,
            repeats: true,
            block: { [weak self] _ in self?.ping() }
        )
    }
    private func ping() {
        self.webSocketTask?.sendPing(pongReceiveHandler: { [weak self] error in
            guard let error = error else { return }
            print("Ping failed \(error)")
            self?.startPing()
        })
    }
}

extension WebSocket: URLSessionWebSocketDelegate {
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?
    ) {
        self.delegate?.urlSession?(
            session,
            webSocketTask: webSocketTask,
            didOpenWithProtocol: `protocol`
        )
    }
    
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
    ) {
        self.delegate?.urlSession?(
            session,
            webSocketTask: webSocketTask,
            didCloseWith: closeCode,
            reason: reason
        )
    }
}
