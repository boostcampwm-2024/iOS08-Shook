import Combine
import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

public final class SettingUIViewController: BaseViewController<SettingViewModel> {
    private let tableView = UITableView()
    private let button = UIButton()
    private let streamingName = SettingTableViewCell(style: .default, reuseIdentifier: nil)
    private let streamingDescription = SettingTableViewCell(style: .default, reuseIdentifier: nil)
    private let placeholderInfo = ["어떤 방송인지 알려주세요!", "방송 내용을 알려주세요!"]
    private let subject: PassthroughSubject<String, Never> = PassthroughSubject()
    private var cancellables = Set<AnyCancellable>()
    
    override public func setupBind() {
        let input = SettingViewModel.Input(
            didWriteStreamingName: subject
        )
        let output = viewModel.transform(input: input)
        
        output.isActive
            .sink { [weak self] isActive in
                guard let self else { return }
                self.button.isEnabled = isActive
            }
            .store(in: &cancellables)
    }
    
    override public func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        
        button.setTitle("방송시작", for: .normal)
        button.isEnabled = false
        
        view.addSubview(tableView)
        view.addSubview(button)
    }
    
    override public func setupStyles() {
        button.backgroundColor = DesignSystemAsset.Color.gray.color
        button.setTitleColor(DesignSystemAsset.Color.mainBlack.color, for: .normal)
        button.layer.cornerRadius = 16
        tableView.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
        view.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
    }
        
    override public func setupLayouts() {
        tableView.ezl.makeConstraint {
            $0.top(to: view.safeAreaLayoutGuide.ezl.top, offset: 30)
                .bottom(to: button.ezl.top)
                .horizontal(to: view, padding: 20)
        }
        button.ezl.makeConstraint {
            $0.height(56)
                .bottom(to: view.safeAreaLayoutGuide.ezl.bottom, offset: -23)
                .horizontal(to: view, padding: 20)
        }
    }
}

extension SettingUIViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        placeholderInfo.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            streamingName.configure(label: "방송정보", placeholder: "플레이스 홀더") { inputValue in
                self.subject.send(inputValue)
            }
            return streamingName
        } else {
            streamingDescription.configure(label: "방송설명", placeholder: "플레이스 홀더") { inputValue in
            }
            return streamingDescription
        }
    }
}
