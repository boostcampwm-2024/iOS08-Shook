import UIKit

// MARK: - SoketTestViewController

public class SoketTestViewController: UIViewController {
    var tableView: UITableView = .init()
    var button: UIButton = .init()

    var data: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    var webSocket = WebSocket.shared

    override public func viewDidLoad() {
        super.viewDidLoad()
        button.backgroundColor = .systemBlue

        view.addSubview(tableView)
        view.addSubview(button)

        button.setTitle("보내기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            webSocket.send(data: ChatMessage(type: .CHAT, content: "HELLo", sender: "iOS", roomId: "1234"))
        }, for: .touchUpInside)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: button.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        tableView.dataSource = self

        try? webSocket.openWebSocket()
        webSocket.send(data: ChatMessage(type: .ENTER, content: "HELLo", sender: "iOS", roomId: "1234"))
        webSocket.delegate = self

        webSocket.receive { [weak self] data in
            guard let self else { return }

            DispatchQueue.main.async {
                guard let data else { return }
                self.data.append(data.content ?? "")
            }
        }
    }
}

// MARK: URLSessionWebSocketDelegate

extension SoketTestViewController: URLSessionWebSocketDelegate {
    public func urlSession(_: URLSession, webSocketTask _: URLSessionWebSocketTask, didOpenWithProtocol _: String?) {}

    public func urlSession(_: URLSession, webSocketTask _: URLSessionWebSocketTask, didCloseWith _: URLSessionWebSocketTask.CloseCode, reason _: Data?) {}
}

// MARK: UITableViewDataSource

extension SoketTestViewController: UITableViewDataSource {
    public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        data.count
    }

    public func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var config = cell.defaultContentConfiguration()
        config.text = data[indexPath.row]
        cell.contentConfiguration = config
        return cell
    }
}
