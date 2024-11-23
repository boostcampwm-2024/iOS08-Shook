import Combine
import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

public final class SettingUIViewController: BaseViewController<BroadcastCollectionViewModel> {
    private let settingTableView = UITableView()
    private let closeBarButton = UIBarButtonItem()
    private let startStreamingButton = UIButton()
    private let streamingNameCell = SettingTableViewCell(style: .default, reuseIdentifier: nil)
    private let streamingDescriptionCell = SettingTableViewCell(style: .default, reuseIdentifier: nil)
    
    private let placeholderStringOfCells = ["어떤 방송인지 알려주세요!", "방송 내용을 알려주세요!"]
    private let viewModelInput = BroadcastCollectionViewModel.Input()
    private var cancellables = Set<AnyCancellable>()
    
    public override func setupBind() {
        let output = viewModel.transform(input: viewModelInput)
        
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
                self.streamingNameCell.setErrorMessage(message: errorMessage)
            }
            .store(in: &cancellables)
    }
    
    public override func setupViews() {
        closeBarButton.image = DesignSystemAsset.Image.xmark24.image
        
        navigationItem.title = "방송설정"
        navigationItem.rightBarButtonItem = closeBarButton
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        settingTableView.rowHeight = UITableView.automaticDimension
        settingTableView.estimatedRowHeight = 100
        
        startStreamingButton.isEnabled = false
        
        view.addSubview(settingTableView)
        view.addSubview(startStreamingButton)
    }
    
    public override func setupStyles() {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .gray
        
        view.backgroundColor = .black

        closeBarButton.style = .plain
        
        settingTableView.backgroundColor = .black
        
        startStreamingButton.setTitle("방송시작", for: .normal)
        startStreamingButton.layer.cornerRadius = 16
        startStreamingButton.titleLabel?.font = .setFont(.body1(weight: .semiBold))
        startStreamingButton.backgroundColor = DesignSystemAsset.Color.gray.color
        startStreamingButton.setTitleColor(DesignSystemAsset.Color.mainBlack.color, for: .normal)
    }
        
    public override func setupLayouts() {
        settingTableView.ezl.makeConstraint {
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        startStreamingButton.addTarget(self, action: #selector(didTapSettingButton), for: .touchUpInside)
        
        closeBarButton.target = self
        closeBarButton.action = #selector(didTapRightBarButton)
    }
    
    @objc
    private func didTapRightBarButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func didTapSettingButton() {
        let newBroadcastUIViewController = BroadcastUIViewController(viewModel: viewModel)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
        
        UIView.transition(with: window, duration: 0.2, options: .transitionCrossDissolve) {
            window.rootViewController = newBroadcastUIViewController
        }
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension SettingUIViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        placeholderStringOfCells.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            streamingNameCell.configure(
                label: "방송이름",
                placeholder: placeholderStringOfCells[indexPath.row]
            ) { inputValue in
                self.viewModelInput.didWriteStreamingName.send(inputValue)
            }
            return streamingNameCell
        } else {
            streamingDescriptionCell.configure(
                label: "방송정보",
                placeholder: placeholderStringOfCells[indexPath.row],
                textDidChange: nil
            )
            return streamingDescriptionCell
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
