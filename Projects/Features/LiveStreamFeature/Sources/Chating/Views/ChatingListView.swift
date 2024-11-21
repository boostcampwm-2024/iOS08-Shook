import UIKit

import BaseFeature
import EasyLayoutModule

final class ChatingListView: BaseView {
    private let titleLabel = UILabel()
    private let chatListView = UITableView()
    private let chatEmptyView = ChatEmptyView()
        
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
