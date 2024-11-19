import Combine
import UIKit

import BaseFeature
import BaseFeatureInterface
import DesignSystem

public final class BroadcastUIViewController: BaseViewController<BroadcastCollectionViewModel> {
    private let stackView = UIStackView()
    private let imageView = UIImageView()
    private let broadcastStateText = UILabel()
    private let willEndButton = UIButton()
    private let subject: PassthroughSubject<Bool, Never> = PassthroughSubject()
    
    public override func setupBind() {
        let input = BroadcastCollectionViewModel.Input(
            didTapStreamingDone: subject
        )
        viewModel.transform(input: input)
    }
    
    public override func setupViews() {
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(broadcastStateText)

        view.addSubview(stackView)
        view.addSubview(willEndButton)
        willEndButton.addTarget(self, action: #selector(willEndButtonTapped), for: .touchUpInside)
    }
    
    public override func setupStyles() {
        stackView.axis = .vertical
        stackView.spacing = 7
        stackView.alignment = .center
        imageView.image = DesignSystemAsset.Image.tv48.image
        
        broadcastStateText.text = "지금은 방송 중"
        willEndButton.setTitle("방송종료", for: .normal)
        willEndButton.layer.cornerRadius = 16
        
        // Fonts
        broadcastStateText.font = .setFont(.title(weight: .bold))
        willEndButton.titleLabel?.font = .setFont(.body1(weight: .semiBold))
        
        // Colors
        broadcastStateText.textColor = .white
        willEndButton.backgroundColor = DesignSystemAsset.Color.mainGreen.color
        willEndButton.setTitleColor( DesignSystemAsset.Color.mainBlack.color, for: .normal)
        view.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
    }
    
    public override func setupLayouts() {
        stackView.ezl.makeConstraint {
            $0.horizontal(to: view.safeAreaLayoutGuide)
                .centerY(to: view)
        }
        
        imageView.ezl.makeConstraint {
            $0.size(with: 117)
                .centerX(to: stackView)
        }
        
        willEndButton.ezl.makeConstraint {
            $0.height(56)
                .bottom(to: view.safeAreaLayoutGuide, offset: -23)
                .horizontal(to: view, padding: 20)
        }
    }
    
    @objc
    func willEndButtonTapped() {
    }
}

// Dummy
public final class BroadcastCollectionViewModel: ViewModel {
    public struct Input {
        let didTapStreamingDone: PassthroughSubject<Bool, Never>
    }
    
    public struct Output {
        
    }
    
    public init() {}
    
    public func transform(input: Input) -> Output {
        input.didTapStreamingDone
            .sink { [weak self] isDone in
                guard let self else { return }
            }
        return Output()
    }
}
