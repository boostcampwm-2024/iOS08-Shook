import Combine
import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

public class SignUpViewController: BaseViewController<SignUpViewModel> {
    private let greetStackView = UIStackView()
    private let textFieldContainerView = UIView()
    private let imageView = UIImageView()
    private let signUpGradientView = SignUpGradientView()
        
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
        
        output.isValid
            .sink { [weak self] isValid in
                self?.animateTextFieldContainerView(by: isValid)
                self?.animateButton(by: isValid)
                self?.animateValidateLabel(by: isValid)
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
        
        view.addSubview(signUpGradientView)
        view.addSubview(welcomeLabel)
        view.addSubview(greetStackView)
        view.addSubview(guideLabel)
        view.addSubview(textFieldContainerView)
        view.addSubview(button)
        view.addSubview(validateLabel)
    }
    
    public override func setupStyles() {
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
        validateLabel.alpha = 0
        
        button.setTitle("시작하기", for: .normal)
        button.setTitleColor(DesignSystemAsset.Color.mainBlack.color, for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .setFont(.body1())
        button.backgroundColor = .gray
    }
    
    public override func setupLayouts() {
        signUpGradientView.ezl.makeConstraint {
            $0.diagonal(to: view)
        }
        
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
        input.didWriteUserName.send(textField.text)
    }
}

// MARK: - Animation
extension SignUpViewController {
    private func animateTextFieldContainerView(by isValid: Bool) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.textFieldContainerView.layer.borderColor = isValid ? DesignSystemAsset.Color.mainGreen.color.cgColor : DesignSystemColors.Color.white.cgColor
        }
    }
    
    private func animateValidateLabel(by isValid: Bool) {
        guard let text = textField.text else { return }
        
        UIView.animateKeyframes(withDuration: 0.4, delay: 0) { [weak self] in
            self?.validateLabel.alpha = (isValid || text.isEmpty) ? 0 : 1
            
            if !isValid {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
                    self?.validateLabel.transform = CGAffineTransform(translationX: -2, y: 0)
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2) {
                    self?.validateLabel.transform = CGAffineTransform(translationX: 2, y: 0)
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.2) {
                    self?.validateLabel.transform = .identity
                }
            }
        }
    }
    
    private func animateButton(by isValid: Bool) {
        button.isEnabled = isValid
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.button.backgroundColor = isValid ? DesignSystemAsset.Color.mainGreen.color : .gray
        }
    }
}
