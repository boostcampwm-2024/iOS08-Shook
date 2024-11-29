import Combine
import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule
import Lottie

public class SignUpViewController: BaseViewController<SignUpViewModel> {
    private let greetStackView = UIStackView()
    private let textFieldContainerView = UIView()
    private let signUpGradientView = SignUpGradientView()
        
    private let welcomeLabel = UILabel()
    private let greetLabel = UILabel()
    private let guideLabel = UILabel()
    private let validateLabel = UILabel()
    
    private let textField = UITextField()
    
    private let button = UIButton()
    
    private let input = SignUpViewModel.Input()
    private var cancellables = Set<AnyCancellable>()
    
    private let confettiAnimationView = LottieAnimationView(name: "confetti", bundle: Bundle(for: DesignSystemResources.self))
    private let shookAnimationView = LottieAnimationView(name: "shook", bundle: Bundle(for: DesignSystemResources.self))
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        confettiAnimationView.play()
        animateViews()
        shookAnimationView.play()
        
        generateContinuousHapticFeedback()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.textField.becomeFirstResponder()
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    public override func setupBind() {
        let output = viewModel.transform(input: input)
        
        output.isValid
            .sink { [weak self] isValid in
                self?.animateTextFieldContainerView(by: isValid)
                self?.animateButton(by: isValid)
                self?.animateValidateLabel(by: isValid)
            }
            .store(in: &cancellables)
        
        output.isSaved
            .sink { [weak self] isSaved in
                if isSaved {
                    self?.textField.resignFirstResponder()
                    self?.dismissWithAnimation()
                }
                // 저장되지 않았을 때 에러 Alert 로 유저에게 알려주기
            }
            .store(in: &cancellables)
    }
    
    public override func setupViews() {
        welcomeLabel.text = "환영합니다"
        greetLabel.text = "에 처음이시군요!"
        guideLabel.text = "닉네임을 입력해주세요"
        textField.placeholder = "닉네임"
        validateLabel.text = "닉네임은 2자리 이상 10자리 이하 문자, 숫자만 입력해주세요"
                
        greetStackView.addArrangedSubview(shookAnimationView)
        greetStackView.addArrangedSubview(greetLabel)
        
        textFieldContainerView.addSubview(textField)
        textField.delegate = self
        
        button.isEnabled = false
        
        view.addSubview(signUpGradientView)
        view.addSubview(confettiAnimationView)
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
        welcomeLabel.alpha = 0
                
        greetLabel.textColor = .white
        guideLabel.textColor = .white
        guideLabel.alpha = 0
        
        greetStackView.spacing = 4
        greetStackView.alpha = 0
        
        textFieldContainerView.layer.borderColor = DesignSystemColors.Color.white.cgColor
        textFieldContainerView.layer.borderWidth = 1
        textFieldContainerView.layer.cornerRadius = 24
        textFieldContainerView.alpha = 0
        
        textField.textColor = .white
        
        validateLabel.font = .setFont(.caption1())
        validateLabel.textColor = .red
        validateLabel.alpha = 0
        
        button.setTitle("시작하기", for: .normal)
        button.setTitleColor(DesignSystemAsset.Color.mainBlack.color, for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .setFont(.body1())
        button.backgroundColor = .gray
        
        confettiAnimationView.contentMode = .scaleAspectFit
        confettiAnimationView.loopMode = .loop
        confettiAnimationView.animationSpeed = 0.5
        
        shookAnimationView.contentMode = .scaleAspectFit
        shookAnimationView.loopMode = .loop
        shookAnimationView.animationSpeed = 0.5
    }
    
    public override func setupLayouts() {
        signUpGradientView.ezl.makeConstraint {
            $0.diagonal(to: view)
        }
        
        welcomeLabel.ezl.makeConstraint {
            $0.top(to: view.safeAreaLayoutGuide, offset: 80)
                .centerX(to: view)
        }
        
        confettiAnimationView.ezl.makeConstraint {
            $0.top(to: view, offset: -(view.frame.size.height / 3.3))
                .horizontal(to: view)
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
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
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
    private func animateViews() {
        UIView.animate(
            withDuration: 1,
            delay: 0.2,
            options: [.curveEaseInOut]) { [weak self] in
                self?.welcomeLabel.transform = CGAffineTransform(translationX: 0, y: -5)
                self?.welcomeLabel.alpha = 1
            }
        
        UIView.animate(
            withDuration: 1,
            delay: 0.4,
            options: [.curveEaseInOut]) { [weak self] in
                self?.greetStackView.transform = CGAffineTransform(translationX: 0, y: -5)
                self?.greetStackView.alpha = 1
                
                self?.guideLabel.transform = CGAffineTransform(translationX: 0, y: -5)
                self?.guideLabel.alpha = 1
            }
        
        UIView.animate(
            withDuration: 1,
            delay: 0.6,
            options: [.curveEaseInOut]) { [weak self] in
                self?.textFieldContainerView.transform = CGAffineTransform(translationX: 0, y: -5)
                self?.textFieldContainerView.alpha = 1
            }
    }
    
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
        if !button.isEnabled && isValid {
            UIView.animate(withDuration: 0.1) {
                self.button.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            } completion: { _ in
                UIView.animate(
                    withDuration: 0.6,
                    delay: 0,
                    usingSpringWithDamping: 0.5,
                    initialSpringVelocity: 1.0,
                    options: .curveEaseInOut
                ) {
                    self.button.transform = .identity
                }
            }
        }
        
        button.isEnabled = isValid
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.button.backgroundColor = isValid ? DesignSystemAsset.Color.mainGreen.color : .gray
        }
    }
}

// MARK: - ViewTransition
extension SignUpViewController {
    private func dismissWithAnimation() {
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            options: [.curveEaseInOut],
            animations: { [weak self] in
                self?.view.alpha = 0
            },
            completion: { [weak self] _ in
                self?.navigationController?.viewControllers.removeAll { $0 === self }
            }
        )
    }
}

// MARK: - Haptic
extension SignUpViewController {
    private func generateContinuousHapticFeedback() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.prepare()
        
        var iteration = 0
        let maxIterations = 6
        let interval = 0.2
        
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            feedbackGenerator.impactOccurred()
            iteration += 1
            if iteration >= maxIterations {
                timer.invalidate()
            }
        }
    }
}
