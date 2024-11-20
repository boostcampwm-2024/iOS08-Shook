import UIKit

import BaseFeature
import EasyLayoutModule

public final class ChatingListView: BaseView {
    private let titleLabel = UILabel()
    private let chatListView = UITableView()
    private let chatEmptyView = ChatEmptyView()
        
    public override func setupViews() {
        addSubview(titleLabel)
        addSubview(chatListView)
        
        titleLabel.text = "실시간 채팅"
       
        chatListView.register(ChatingCell.self, forCellReuseIdentifier: ChatingCell.identifier)
        chatListView.backgroundView = chatEmptyView
    }
    
    public override func setupStyles() {
        titleLabel.textColor = .white
        titleLabel.font = .setFont(.body1())
        
        chatListView.backgroundColor = .clear
    }
    
    public override func setupLayouts() {
        titleLabel.ezl.makeConstraint {
            $0.top(to: self)
                .leading(to: self)
        }
        
        chatListView.ezl.makeConstraint {
            $0.horizontal(to: self)
                .top(to: titleLabel.ezl.bottom, offset: 21)
                .bottom(to: self)
        }
    }
}
