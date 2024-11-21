import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

public final class ChatingViewController: BaseViewController<ChatingViewModel> {
    private let chatingList = ChatingListView()
    private let chatInputField = ChatInputField()
    
    public override func setupLayouts() {
        view.addSubview(chatingList)
        view.addSubview(chatInputField)
        
        chatingList.ezl.makeConstraint {
            $0.top(to: view.safeAreaLayoutGuide)
                .horizontal(to: view)
                .bottom(to: chatInputField.ezl.top)
        }
        
        chatInputField.ezl.makeConstraint {
            $0.horizontal(to: view)
                .bottom(to: view.keyboardLayoutGuide.ezl.top)
        }
    }
}
