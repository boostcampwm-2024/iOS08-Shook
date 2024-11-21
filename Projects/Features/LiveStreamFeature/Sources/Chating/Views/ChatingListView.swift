import UIKit

import BaseFeature
import EasyLayoutModule

final class ChatingListView: BaseView {
    private let titleLabel = UILabel()
    private let chatListView = UITableView(frame: .zero, style: .plain)
    private let chatEmptyView = ChatEmptyView()
    
    private lazy var dataSource = UITableViewDiffableDataSource<Int, ChatInfo>(
        tableView: chatListView
    ) { [weak self] tableView, indexPath, chatInfo in
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatingCell.identifier,
            for: indexPath
        ) as? ChatingCell ?? ChatingCell()
        cell.configure(chat: chatInfo)
        return cell
    }
    
    override func setupViews() {
        addSubview(titleLabel)
        addSubview(chatListView)
        
        titleLabel.text = "실시간 채팅"
        
        chatListView.register(ChatingCell.self, forCellReuseIdentifier: ChatingCell.identifier)
        chatListView.backgroundView = chatEmptyView
    }
    
    override func setupStyles() {
        titleLabel.textColor = .white
        titleLabel.font = .setFont(.body1())
        
        chatListView.backgroundColor = .clear
        chatListView.keyboardDismissMode = .interactive
        chatListView.allowsSelection = false
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
}

extension ChatingListView {
    func updateList(_ chatList: [ChatInfo]) {
        chatEmptyView.isHidden = !chatList.isEmpty
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, ChatInfo>()
        snapshot.appendSections([0])
        snapshot.appendItems(chatList)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}
