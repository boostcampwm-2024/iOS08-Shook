import Combine
import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

public final class SettingUIViewController: BaseViewController<SettingViewModel> {
    private let rightBarButton = UIBarButtonItem()
    private let tableView = UITableView()
    private let button = UIButton()
    private let streamingName = SettingTableViewCell(style: .default, reuseIdentifier: nil)
    private let streamingDescription = SettingTableViewCell(style: .default, reuseIdentifier: nil)
    
    private let placeholderInfo = ["어떤 방송인지 알려주세요!", "방송 내용을 알려주세요!"]
    private let input = SettingViewModel.Input()
    private var cancellables = Set<AnyCancellable>()
    
    public override func setupBind() {
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
        
        output.errorMessage
            .sink { [weak self] errorMessage in
                guard let self else { return }
                self.streamingName.setErrorMessage(message: errorMessage)
            }
            .store(in: &cancellables)
    }
    
    public override func setupViews() {
        rightBarButton.image = UIImage(systemName: "xmark")
        
        navigationItem.title = "방송설정"
        navigationItem.rightBarButtonItem = rightBarButton
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        button.isEnabled = false
        
        view.addSubview(tableView)
        view.addSubview(button)
    }
    
    public override func setupStyles() {
        rightBarButton.style = .plain
        
        view.backgroundColor = .black
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        
        tableView.backgroundColor = .black
        
        button.setTitle("방송시작", for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .setFont(.body1(weight: .semiBold))
        button.backgroundColor = DesignSystemAsset.Color.gray.color
        button.setTitleColor(DesignSystemAsset.Color.mainBlack.color, for: .normal)
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
    
    public override func setupActions() {
        startStreamingButton.addTarget(self, action: #selector(didTapSettingButton), for: .touchUpInside)
        rightBarButton.target = self
        rightBarButton.action = #selector(didTapRightBarButton)
    }
    
    @objc
    private func didTapRightBarButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func didTapSettingButton() {
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
                self.input.didWriteStreamingName.send(inputValue)
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
