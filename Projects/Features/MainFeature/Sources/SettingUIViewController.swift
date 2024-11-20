import Combine
import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

public final class SettingUIViewController: BaseViewController<BroadcastCollectionViewModel> {
    private let rightBarButton = UIBarButtonItem()
    private let tableView = UITableView()
    private let startStreamingButton = UIButton()
    private let streamingName = SettingTableViewCell(style: .default, reuseIdentifier: nil)
    private let streamingDescription = SettingTableViewCell(style: .default, reuseIdentifier: nil)
    
    private let placeholderInfo = ["어떤 방송인지 알려주세요!", "방송 내용을 알려주세요!"]
    private let input = BroadcastCollectionViewModel.Input()
    private var cancellables = Set<AnyCancellable>()
    
    public override func setupBind() {
        let output = viewModel.transform(input: input)
        
        output.isActive
            .sink { [weak self] isActive in
                guard let self else { return }
                self.startStreamingButton.isEnabled = isActive
                self.startStreamingButton.backgroundColor = isActive
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
        
        startStreamingButton.isEnabled = false
        
        view.addSubview(tableView)
        view.addSubview(startStreamingButton)
    }
    
    public override func setupStyles() {
        rightBarButton.style = .plain
        
        view.backgroundColor = .black
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        
        tableView.backgroundColor = .black
        
        startStreamingButton.setTitle("방송시작", for: .normal)
        startStreamingButton.layer.cornerRadius = 16
        startStreamingButton.titleLabel?.font = .setFont(.body1(weight: .semiBold))
        startStreamingButton.backgroundColor = DesignSystemAsset.Color.gray.color
        startStreamingButton.setTitleColor(DesignSystemAsset.Color.mainBlack.color, for: .normal)
    }
        
    public override func setupLayouts() {
        tableView.ezl.makeConstraint {
            $0.top(to: view.safeAreaLayoutGuide, offset: 21)
                .bottom(to: startStreamingButton.ezl.top)
                .horizontal(to: view, padding: 20)
        }
        
        startStreamingButton.ezl.makeConstraint {
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
        let newViewController = BroadcastUIViewController(viewModel: viewModel)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
        
        UIView.transition(with: window, duration: 0.2, options: .transitionCrossDissolve) {
            window.rootViewController = newViewController
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
