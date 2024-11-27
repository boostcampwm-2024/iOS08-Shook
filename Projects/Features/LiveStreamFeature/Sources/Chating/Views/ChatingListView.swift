import Combine
import UIKit

import DesignSystem
import BaseFeature
import EasyLayoutModule

protocol ChatInputFieldAction {
    var sendButtonDidTap: AnyPublisher<ChatInfo?, Never> { get }
}

final class ChattingListView: BaseView {
    private let titleLabel = UILabel()
    private let chatListView = UITableView(frame: .zero, style: .plain)
    private let chatEmptyView = ChatEmptyView()
    private let chatInputField = ChatInputField()
    private let recentChatButton = UIButton()

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
        addSubview(recentChatButton)
        addSubview(chatInputField)
        
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
        
        var configure = UIButton.Configuration.filled()
        configure.title = "최근 채팅으로 이동"
        configure.baseBackgroundColor = DesignSystemAsset.Color.mainGreen.color
        configure.baseForegroundColor = .white
        recentChatButton.configuration = configure
    }
    
    override func setupLayouts() {
        titleLabel.ezl.makeConstraint {
            $0.top(to: self)
                .leading(to: self, offset: 20)
        }
        
        chatListView.ezl.makeConstraint {
            $0.horizontal(to: self)
                .top(to: titleLabel.ezl.bottom, offset: 21)
                .bottom(to: chatInputField.ezl.top)
        }
        
        chatInputField.ezl.makeConstraint {
            $0.horizontal(to: self)
                .bottom(to: self)
        }
        
        recentChatButton.ezl.makeConstraint {
            $0.centerX(to: self)
                .bottom(to: chatInputField.ezl.top, offset: -8)
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

extension ChattingListView: ChatInputFieldAction {
    var sendButtonDidTap: AnyPublisher<ChatInfo?, Never> {
        chatInputField.$sendButtonDidTapPublisher.dropFirst().eraseToAnyPublisher()
    }
}
