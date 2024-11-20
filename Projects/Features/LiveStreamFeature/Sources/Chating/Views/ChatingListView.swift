import UIKit

import BaseFeature
import EasyLayoutModule

public final class ChatingListView: BaseView {
    private let titleLabel = UILabel()
    private let chatListView = UITableView()
    private let chatEmptyView = ChatEmptyView()
    private let chatInputField = ChatInputField()
        
    public override func setupViews() {
        addSubview(titleLabel)
        addSubview(chatListView)
        addSubview(chatInputField)
        
        titleLabel.text = "실시간 채팅"
       
        chatListView.register(ChatingCell.self, forCellReuseIdentifier: ChatingCell.identifier)
        chatListView.backgroundView = chatEmptyView
    }
    
    public override func setupStyles() {
        titleLabel.textColor = .white
        titleLabel.font = .setFont(.body1())
        
        chatListView.backgroundColor = .clear
        chatListView.keyboardDismissMode = .interactive
    }
    
    public override func setupLayouts() {
        titleLabel.ezl.makeConstraint {
            $0.top(to: self)
                .leading(to: self)
        }
        
        chatListView.ezl.makeConstraint {
            $0.horizontal(to: self)
                .top(to: titleLabel.ezl.bottom, offset: 21)
                .bottom(to: chatInputField.ezl.top)
        }
        
        chatInputField.ezl.makeConstraint {
            $0.horizontal(to: self)
                .bottom(to: self.keyboardLayoutGuide.ezl.top)
        }
    }
}
