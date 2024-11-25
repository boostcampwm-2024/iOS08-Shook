import Combine
import ReplayKit
import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

public final class SettingUIViewController: BaseViewController<BroadcastCollectionViewModel> {
    deinit {
        viewModel.sharedDefaults.removeObserver(self, forKeyPath: viewModel.isStreamingKey)
    }
    private let settingTableView = UITableView()
    private let closeBarButton = UIBarButtonItem()
    private let startStreamingButton = UIButton()
    private let streamingDescriptionCell = SettingTableViewCell(style: .default, reuseIdentifier: nil)
    private let streamingNameCell = SettingTableViewCell(style: .default, reuseIdentifier: nil)
    private let placeholderStringOfCells = ["어떤 방송인지 알려주세요!", "방송 내용을 알려주세요!"]
    
    private var broadcastPicker = RPSystemBroadcastPickerView()
    
    private let viewModelInput = BroadcastCollectionViewModel.Input()
    private var cancellables = Set<AnyCancellable>()
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == viewModel.isStreamingKey {
            if let newValue = change?[.newKey] as? Bool, newValue == true {
                didStartBroadCast()
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    public override func setupBind() {
        let output = viewModel.transform(input: viewModelInput)
        
        output.streamingStartButtonIsActive
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
        
        viewModel.sharedDefaults.addObserver(self, forKeyPath: viewModel.isStreamingKey, options: [.initial, .new], context: nil)
        viewModel.sharedDefaults.set(false, forKey: viewModel.isStreamingKey)
        
        navigationItem.title = "방송설정"
        navigationItem.rightBarButtonItem = closeBarButton
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        settingTableView.rowHeight = UITableView.automaticDimension
        settingTableView.estimatedRowHeight = 100
        
        broadcastPicker.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        broadcastPicker.preferredExtension = viewModel.extensionBundleID

        startStreamingButton.isEnabled = false
        startStreamingButton.addSubview(broadcastPicker)
        
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
        
        broadcastPicker.ezl.makeConstraint {
            $0.center(to: startStreamingButton)
                .width(startStreamingButton.frame.width)
                .height(startStreamingButton.frame.height)
        }
    }
    
    public override func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        startStreamingButton.addTarget(self, action: #selector(didTapSettingButton), for: .touchUpInside)
        
        closeBarButton.target = self
        closeBarButton.action = #selector(didTapRightBarButton)
    }
    
    /// X 모양 버튼이 눌렸을 때 호출되는 메서드
    @objc
    private func didTapRightBarButton() {
        dismiss(animated: true, completion: nil)
    }
    
    /// 방송 시작 버튼이 눌렸을 때 호출되는 메서드
    @objc
    private func didTapSettingButton() {
        guard let broadcastPickerButton = broadcastPicker.subviews.first(where: { $0 is UIButton }) as? UIButton else { return }
        broadcastPickerButton.sendActions(for: .touchUpInside)
    }
    
    private func didStartBroadCast() {
        let newBroadcastCollectionViewController = BroadcastUIViewController(viewModel: viewModel)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
        
        UIView.transition(with: window, duration: 0, options: .transitionCrossDissolve) {
            window.rootViewController = newBroadcastCollectionViewController
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
        UITableView.automaticDimension
    }
}
