import Combine
import ReplayKit
import UIKit

import BaseFeature
import BaseFeatureInterface
import DesignSystem

public final class BroadcastUIViewController: BaseViewController<BroadcastCollectionViewModel> {
    deinit {
        viewModel.sharedDefaults.removeObserver(self, forKeyPath: viewModel.isStreamingKey)
    }
    
    private let broadcastStatusStackView = UIStackView()
    private let broadcastStatusImageView = UIImageView()
    private let broadcastStateText = UILabel()
    private let endBroadcastButton = UIButton()
    
    private let viewModelInput = BroadcastCollectionViewModel.Input()
    
    public override func setupBind() {
        _ = viewModel.transform(input: viewModelInput)
    }
    
    private var broadcastPicker = RPSystemBroadcastPickerView()
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == viewModel.isStreamingKey {
            if let newValue = change?[.newKey] as? Bool, !newValue {
                didFinishBroadCast()
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    public override func setupViews() {
        broadcastPicker.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        broadcastPicker.preferredExtension = viewModel.extensionBundleID
        
        endBroadcastButton.addSubview(broadcastPicker)
        
        viewModel.sharedDefaults.addObserver(self, forKeyPath: viewModel.isStreamingKey, options: [.initial, .new], context: nil)
        
        broadcastStatusStackView.addArrangedSubview(broadcastStatusImageView)
        broadcastStatusStackView.addArrangedSubview(broadcastStateText)
        
        view.addSubview(broadcastStatusStackView)
        view.addSubview(endBroadcastButton)
    }
    
    public override func setupStyles() {        
        broadcastStatusStackView.axis = .vertical
        broadcastStatusStackView.spacing = 7
        broadcastStatusStackView.alignment = .center
        broadcastStatusImageView.image = DesignSystemAsset.Image.tv48.image
        broadcastStateText.text = "지금은 방송 중"
        broadcastStateText.font = .setFont(.title())
        broadcastStateText.textColor = .white

        endBroadcastButton.setTitle("방송종료", for: .normal)
        endBroadcastButton.layer.cornerRadius = 16
        endBroadcastButton.titleLabel?.font = .setFont(.body1())
        endBroadcastButton.backgroundColor = DesignSystemAsset.Color.mainGreen.color
        endBroadcastButton.setTitleColor(DesignSystemAsset.Color.mainBlack.color, for: .normal)
    }
    
    public override func setupLayouts() {
        broadcastStatusStackView.ezl.makeConstraint {
            $0.horizontal(to: view.safeAreaLayoutGuide)
                .centerY(to: view)
        }
        
        broadcastStatusImageView.ezl.makeConstraint {
            $0.size(with: 117)
                .centerX(to: broadcastStatusStackView)
        }
        
        endBroadcastButton.ezl.makeConstraint {
            $0.height(56)
                .bottom(to: view.safeAreaLayoutGuide, offset: -23)
                .horizontal(to: view, padding: 20)
        }
        
        broadcastPicker.ezl.makeConstraint {
            $0.center(to: endBroadcastButton)
                .width(endBroadcastButton.frame.width)
                .height(endBroadcastButton.frame.height)
        }
    }
    
    public override func setupActions() {
        endBroadcastButton.addTarget(self, action: #selector(didTapEndButton), for: .touchUpInside)
    }
    
    @objc
    private func didTapEndButton() {
        guard let broadcastPickerButton = broadcastPicker.subviews.first(where: { $0 is UIButton }) as? UIButton else { return }
        broadcastPickerButton.sendActions(for: .touchUpInside)
    }
    
    private func didFinishBroadCast() {
        dismiss(animated: false) { [weak self] in
            self?.viewModelInput.didTapFinishStreamingButton.send()
        }
    }
}
