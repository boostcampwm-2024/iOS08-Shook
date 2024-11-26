import Combine
import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

public class SignUpViewController: BaseViewController<SignUpViewModel> {
    private let greetStackView = UIStackView()
    private let textFieldContainerView = UIView()
    private let imageView = UIImageView()
    
    private let welcomeLabel = UILabel()
    private let greetLabel = UILabel()
    private let guideLabel = UILabel()
    private let validateLabel = UILabel()
    
    private let textField = UITextField()
    
    private let button = UIButton()
    
    private let input = SignUpViewModel.Input()
    private var cancellables = Set<AnyCancellable>()
    
    public override func setupBind() {
        let output = viewModel.transform(input: input)
        
        output.isValidate
            .sink { [weak self] isValidate in
                self?.button.isEnabled = isValidate
                self?.button.backgroundColor = isValidate ? DesignSystemAsset.Color.mainGreen.color : .gray
                self?.validateLabel.isHidden = isValidate
            }
            .store(in: &cancellables)
    }
    
    public override func setupViews() {
        welcomeLabel.text = "환영합니다"
        greetLabel.text = "에 처음이시군요!"
        guideLabel.text = "닉네임을 입력해주세요"
        textField.placeholder = "닉네임"
        validateLabel.text = "닉네임은 2자리 이상 10자리 이하 문자, 숫자만 입력해주세요"
        
        imageView.image = DesignSystemAsset.Image.appIconSmall.image
        
        greetStackView.addArrangedSubview(imageView)
        greetStackView.addArrangedSubview(greetLabel)
        
        textFieldContainerView.addSubview(textField)
        textField.delegate = self
        
        button.isEnabled = false
        validateLabel.isHidden = true
        
        view.addSubview(welcomeLabel)
        view.addSubview(greetStackView)
        view.addSubview(guideLabel)
        view.addSubview(textFieldContainerView)
        view.addSubview(button)
        view.addSubview(validateLabel)
    }
    
    public override func setupStyles() {
        view.backgroundColor = .black
        
        welcomeLabel.textColor = .white
        welcomeLabel.font = .systemFont(ofSize: 32, weight: .bold)
        
        imageView.contentMode = .scaleAspectFit
        
        greetLabel.textColor = .white
        guideLabel.textColor = .white
        
        greetStackView.spacing = 4
        
        textFieldContainerView.backgroundColor = .clear
        textFieldContainerView.layer.borderColor = DesignSystemColors.Color.white.cgColor
        textFieldContainerView.layer.borderWidth = 1
        textFieldContainerView.layer.cornerRadius = 24
        
        validateLabel.font = .setFont(.caption1())
        validateLabel.textColor = .red
        
        button.setTitle("시작하기", for: .normal)
        button.setTitleColor(DesignSystemAsset.Color.mainBlack.color, for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .setFont(.body1())
        button.backgroundColor = .gray
    }
    
    public override func setupLayouts() {
        welcomeLabel.ezl.makeConstraint {
            $0.top(to: view.safeAreaLayoutGuide, offset: 80)
                .centerX(to: view)
        }
        
        greetStackView.ezl.makeConstraint {
            $0.top(to: welcomeLabel.ezl.bottom, offset: 48)
                .centerX(to: view)
        }
        
        guideLabel.ezl.makeConstraint {
            $0.top(to: greetStackView.ezl.bottom, offset: 16)
                .centerX(to: view)
        }
        
        textFieldContainerView.ezl.makeConstraint {
            $0.top(to: guideLabel.ezl.bottom, offset: 56)
                .horizontal(to: view, padding: 40)
                .height(48)
        }
        
        textField.ezl.makeConstraint {
            $0.vertical(to: textFieldContainerView, padding: 4)
                .horizontal(to: textFieldContainerView, padding: 24)
        }
        
        validateLabel.ezl.makeConstraint {
            $0.top(to: textFieldContainerView.ezl.bottom, offset: 8)
                .leading(to: textFieldContainerView, offset: 24)
        }
        
        button.ezl.makeConstraint {
            $0.height(56)
                .bottom(to: view.keyboardLayoutGuide.ezl.top, offset: -16)
                .horizontal(to: view, padding: 20)
        }
    }
    
    public override func setupActions() {
        button.addAction(UIAction { [weak self] _ in
            self?.input.saveUserName.send(self?.textField.text)
        }, for: .touchUpInside)
    }
}

// MARK: - TextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        updateTextFieldBorderColor()
    }
    
    private func updateTextFieldBorderColor() {
        if let text = textField.text, !text.isEmpty {
            textFieldContainerView.layer.borderColor = DesignSystemAsset.Color.mainGreen.color.cgColor
            input.didWriteUserName.send(text)
        } else {
            textFieldContainerView.layer.borderColor = DesignSystemColors.Color.white.cgColor
            validateLabel.isHidden = true
        }
    }
}
