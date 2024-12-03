import UIKit

public class SoketTestViewController: UIViewController {

    var tableView: UITableView = UITableView()
    var button: UIButton = UIButton()
    
    var data: [String] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var webSocket = WebSocket.shared
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        button.backgroundColor = .systemBlue
        
        view.addSubview(tableView)
        view.addSubview(button)
        
        button.setTitle("보내기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addAction(UIAction(handler: { [weak self] _  in
            guard let self else { return }
            self.webSocket.send(data: ChatMessage(type: .CHAT, content: "HELLo", sender: "iOS", roomId: "1234"))
        }), for: .touchUpInside)
        
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
        
        webSocket.receive {[weak self] data in
            guard let self else { return }
          
            DispatchQueue.main.async {
                guard let data else {return }
                self.data.append(data.content ?? "")
            }
        }
        
    }
    
}

extension SoketTestViewController: URLSessionWebSocketDelegate {
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        
    }
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
     
    }
}

extension SoketTestViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var config = cell.defaultContentConfiguration()
        config.text = data[indexPath.row]
        cell.contentConfiguration = config
        return cell
    }
}
