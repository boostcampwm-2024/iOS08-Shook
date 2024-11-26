import UIKit

import BaseFeature
import EasyLayoutModule

final class ChattingListView: BaseView {
    private let titleLabel = UILabel()
    private let chatListView = UITableView(frame: .zero, style: .plain)
    private let chatEmptyView = ChatEmptyView()
    
    private lazy var dataSource = UITableViewDiffableDataSource<Int, ChatInfo>(
        tableView: chatListView
    ) { tableView, indexPath, chatInfo in
        switch chatInfo.owner {
        case .user:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ChattingCell.identifier,
                for: indexPath
            ) as? ChattingCell ?? ChattingCell()
            
            cell.configure(chat: chatInfo)
            return cell
            
        case .system:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SystemAlarmCell.identifier,
                for: indexPath
            ) as? SystemAlarmCell ?? SystemAlarmCell()
            
            cell.configure(content: chatInfo.message)
            return cell
        }
    }
    
    override func setupViews() {
        addSubview(titleLabel)
        addSubview(chatListView)
        
        titleLabel.text = "실시간 채팅"
        
        chatListView.register(ChattingCell.self, forCellReuseIdentifier: ChattingCell.identifier)
        chatListView.register(SystemAlarmCell.self, forCellReuseIdentifier: SystemAlarmCell.identifier)
        chatListView.backgroundView = chatEmptyView
    }
    
    override func setupStyles() {
        titleLabel.textColor = .white
        titleLabel.font = .setFont(.body1())
        
        chatListView.backgroundColor = .clear
        chatListView.keyboardDismissMode = .interactive
        chatListView.allowsSelection = false
        chatListView.separatorStyle = .none
    }
    
    override func setupLayouts() {
        titleLabel.ezl.makeConstraint {
            $0.top(to: self)
                .leading(to: self, offset: 20)
        }
        
        chatListView.ezl.makeConstraint {
            $0.horizontal(to: self)
                .top(to: titleLabel.ezl.bottom, offset: 21)
                .bottom(to: self)
        }
    }
    
    private func scrollToBottom() {
        let lastRowIndex = chatListView.numberOfRows(inSection: 0) - 1
        guard lastRowIndex >= 0 else { return }
        let indexPath = IndexPath(row: lastRowIndex, section: 0)
        chatListView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

extension ChattingListView {
    func updateList(_ chatList: [ChatInfo]) {
        chatEmptyView.isHidden = !chatList.isEmpty
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, ChatInfo>()
        snapshot.appendSections([0])
        snapshot.appendItems(chatList)
        self.dataSource.apply(snapshot, animatingDifferences: false)
        scrollToBottom()
    }
}
