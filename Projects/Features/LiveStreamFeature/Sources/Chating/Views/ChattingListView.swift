import Combine
import UIKit

import BaseFeature
import DesignSystem
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
    
    @Published private var isScrollFixed = true
    
    private var recentChatButtonShowConstraints: [NSLayoutConstraint] = []
    private var recentChatButtonHideConstraints: [NSLayoutConstraint] = []
    
    private var subscription = Set<AnyCancellable>()

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
        
        chatListView.delegate = self
        chatListView.register(ChattingCell.self, forCellReuseIdentifier: ChattingCell.identifier)
        chatListView.register(SystemAlarmCell.self, forCellReuseIdentifier: SystemAlarmCell.identifier)
        chatListView.backgroundView = chatEmptyView
        chatListView.bounces = false
    }
    
    override func setupStyles() {
        titleLabel.font = .setFont(.body1())
        
        chatListView.backgroundColor = .clear
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
        
        recentChatButton.translatesAutoresizingMaskIntoConstraints = false
        recentChatButtonShowConstraints = [
            recentChatButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            recentChatButton.bottomAnchor.constraint(equalTo: chatInputField.topAnchor, constant: -8)
        ]
        recentChatButtonHideConstraints = [
            recentChatButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            recentChatButton.bottomAnchor.constraint(equalTo: chatInputField.bottomAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(recentChatButtonHideConstraints)
    }
    
    override func setupActions() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.addGestureRecognizer(tapGesture)
        
        $isScrollFixed
            .sink { [weak self] in
                self?.updateRecentChatButtonConstraint(isHidden: $0)
            }
            .store(in: &subscription)
        
        recentChatButton.addAction(
            UIAction { [weak self] _ in
                self?.updateRecentChatButtonConstraint(isHidden: true)
                self?.scrollToBottom()
            },
            for: .touchUpInside
        )
        
        sendButtonDidTap
            .sink { [weak self] _ in
                self?.isScrollFixed = true
            }
            .store(in: &subscription)
    }
    
    private func lastIndexPath() -> IndexPath? {
        let lastRowIndex = chatListView.numberOfRows(inSection: 0) - 1
        guard lastRowIndex >= 0 else { return nil }
        return IndexPath(row: lastRowIndex, section: 0)
    }
    
    private func scrollToBottom() {
        guard let indexPath = lastIndexPath() else { return }
        chatListView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    private func updateRecentChatButtonConstraint(isHidden: Bool) {
        UIView.animate(withDuration: 0.2) {
            if isHidden {
                NSLayoutConstraint.deactivate(self.recentChatButtonShowConstraints)
                NSLayoutConstraint.activate(self.recentChatButtonHideConstraints)
            } else {
                NSLayoutConstraint.deactivate(self.recentChatButtonHideConstraints)
                NSLayoutConstraint.activate(self.recentChatButtonShowConstraints)
            }
            self.layoutIfNeeded()
        }
    }
    
    @objc
    private func dismissKeyboard() {
        endEditing(true)
    }
}

extension ChattingListView {
    func updateList(_ chatList: [ChatInfo]) {
        chatEmptyView.isHidden = !chatList.isEmpty
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, ChatInfo>()
        snapshot.appendSections([0])
        snapshot.appendItems(chatList)
        self.dataSource.apply(snapshot, animatingDifferences: false)
        if isScrollFixed {
            scrollToBottom()
        }
    }
}

extension ChattingListView: ChatInputFieldAction {
    var sendButtonDidTap: AnyPublisher<ChatInfo?, Never> {
        chatInputField.$sendButtonDidTapPublisher.dropFirst().eraseToAnyPublisher()
    }
}

extension ChattingListView: UITableViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let lastIndexPath = lastIndexPath(),
              let indexPathList = chatListView.indexPathsForVisibleRows else { return }
        isScrollFixed = indexPathList.contains(lastIndexPath)
    }
}
