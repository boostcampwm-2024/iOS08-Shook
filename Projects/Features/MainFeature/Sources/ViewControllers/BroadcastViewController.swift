import Combine
import ReplayKit
import UIKit

import BaseFeature
import BaseFeatureInterface
import DesignSystem

public final class BroadcastViewController: BaseViewController<SettingViewModel> {
    deinit {
        viewModel.sharedDefaults?.removeObserver(self, forKeyPath: viewModel.isStreamingKey)
    }

    private let broadcastStatusStackView = UIStackView()
    private let broadcastStatusImageView = UIImageView()
    private let broadcastStateText = UILabel()
    private let finshBroadcastButton = UIButton()

    private let viewModelInput = SettingViewModel.Input()

    override public func setupBind() {
        _ = viewModel.transform(input: viewModelInput)
    }

    private var broadcastPicker = RPSystemBroadcastPickerView()

    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == viewModel.isStreamingKey {
            if let newValue = change?[.newKey] as? Bool, !newValue {
                didFinishBroadCast()
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    override public func setupViews() {
        broadcastPicker.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        broadcastPicker.preferredExtension = viewModel.extensionBundleID
        broadcastPicker.showsMicrophoneButton = false

        finshBroadcastButton.addSubview(broadcastPicker)

        viewModel.sharedDefaults?.addObserver(self, forKeyPath: viewModel.isStreamingKey, options: [.initial, .new], context: nil)

        broadcastStatusStackView.addArrangedSubview(broadcastStatusImageView)
        broadcastStatusStackView.addArrangedSubview(broadcastStateText)

        view.addSubview(broadcastStatusStackView)
        view.addSubview(finshBroadcastButton)
    }

    override public func setupStyles() {
        view.backgroundColor = .systemBackground

        broadcastStatusStackView.axis = .vertical
        broadcastStatusStackView.spacing = 7
        broadcastStatusStackView.alignment = .center
        broadcastStatusImageView.image = DesignSystemAsset.Image.tv48.image
        broadcastStateText.text = "지금은 방송 중"
        broadcastStateText.font = .setFont(.title())
        broadcastStateText.textColor = .white

        finshBroadcastButton.setTitle("방송종료", for: .normal)
        finshBroadcastButton.layer.cornerRadius = 16
        finshBroadcastButton.titleLabel?.font = .setFont(.body1())
        finshBroadcastButton.backgroundColor = DesignSystemAsset.Color.mainGreen.color
        finshBroadcastButton.setTitleColor(DesignSystemAsset.Color.mainBlack.color, for: .normal)
    }

    override public func setupLayouts() {
        broadcastStatusStackView.ezl.makeConstraint {
            $0.horizontal(to: view.safeAreaLayoutGuide)
                .centerY(to: view)
        }

        broadcastStatusImageView.ezl.makeConstraint {
            $0.size(with: 117)
                .centerX(to: broadcastStatusStackView)
        }

        finshBroadcastButton.ezl.makeConstraint {
            $0.height(56)
                .bottom(to: view.safeAreaLayoutGuide, offset: -23)
                .horizontal(to: view, padding: 20)
        }

        broadcastPicker.ezl.makeConstraint {
            $0.center(to: finshBroadcastButton)
                .width(finshBroadcastButton.frame.width)
                .height(finshBroadcastButton.frame.height)
        }
    }

    override public func setupActions() {
        finshBroadcastButton.addTarget(self, action: #selector(didTapFinishButton), for: .touchUpInside)
    }

    @objc
    private func didTapFinishButton() {
        guard let broadcastPickerButton = broadcastPicker.subviews.first(where: { $0 is UIButton }) as? UIButton else { return }
        broadcastPickerButton.sendActions(for: .touchUpInside)
    }

    private func didFinishBroadCast() {
        viewModelInput.didTapFinishStreamingButton.send()
        dismiss(animated: false)
    }
}
