import Combine
import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

public final class ChatingViewController: BaseViewController<ChatingViewModel> {
    private let chatingList = ChatingListView()
    private let chatInputField = ChatInputField()
    
    private var cancellables = Set<AnyCancellable>()
    private let input = ChatingViewModel.Input()
    
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
    
    public override func setupBind() {
        let output = viewModel.transform(input: input)
        
        output.chatList
            .sink { [weak self] in
                self?.chatingList.updateList($0)
            }.store(in: &cancellables)
    }
}
