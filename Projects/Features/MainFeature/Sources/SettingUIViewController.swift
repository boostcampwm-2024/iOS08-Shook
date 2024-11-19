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
    private let placeholderInfo = ["3~20글자 입력해주세요!", "방송 내용을 알려주세요!"]
    private let subject: PassthroughSubject<String, Never> = PassthroughSubject()
    private var cancellables = Set<AnyCancellable>()
    
    public override func setupBind() {
        let input = SettingViewModel.Input(
            didWriteStreamingName: subject
        )
        let output = viewModel.transform(input: input)
        
        output.isActive
            .sink { [weak self] isActive in
                guard let self else { return }
                self.button.isEnabled = isActive
                self.button.backgroundColor = isActive
                    ? DesignSystemAsset.Color.mainGreen.color
                    : DesignSystemAsset.Color.gray.color
            }
            .store(in: &cancellables)
    }
    
    public override func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        button.isEnabled = false
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        view.addSubview(tableView)
        view.addSubview(button)
    }
    
    public override func setupStyles() {
        button.setTitle("방송시작", for: .normal)
        button.layer.cornerRadius = 16
        
        // Fonts
        button.titleLabel?.font = .setFont(.body1(weight: .semiBold))
        
        // Colors
        button.backgroundColor = DesignSystemAsset.Color.gray.color
        button.setTitleColor(DesignSystemAsset.Color.mainBlack.color, for: .normal)
        tableView.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
        view.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
    }
        
    public override func setupLayouts() {
        tableView.ezl.makeConstraint {
            $0.top(to: view.safeAreaLayoutGuide, offset: 30)
                .bottom(to: button.ezl.top)
                .horizontal(to: view, padding: 20)
        }
        button.ezl.makeConstraint {
            $0.height(56)
                .bottom(to: view.safeAreaLayoutGuide, offset: -23)
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
            streamingName.configure(
                label: "방송이름",
                placeholder: placeholderInfo[indexPath.row]
            ) { inputValue in
                self.subject.send(inputValue)
            }
            return streamingName
        } else {
            streamingDescription.configure(
                label: "방송정보",
                placeholder: placeholderInfo[indexPath.row],
                textDidChange: nil
            )
            return streamingDescription
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
