import Combine
import Foundation

import BaseFeatureInterface

public class SignUpViewModel: ViewModel {
    public struct Input {
        let didWriteUserName: PassthroughSubject<String, Never> = .init()
        let saveUserName: PassthroughSubject<String?, Never> = .init()
    }
    public struct Output {
        let isValid: PassthroughSubject<Bool, Never> = .init()
    }
    
    private let output = Output()
    private var cancellables = Set<AnyCancellable>()
    
    public func transform(input: Input) -> Output {
        input.didWriteUserName
            .sink { [weak self] name in
                if let isValid = self?.validate(with: name) {
                    self?.output.isValid.send(isValid)
                }
            }
            .store(in: &cancellables)
        
        input.saveUserName
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { [weak self] name in
                self?.save(for: name)
            }
            .store(in: &cancellables)
        
        return output
    }
    
    public init() { }
    
    private func validate(with name: String) -> Bool {
        name.count >= 2 && name.count <= 10 && name.allSatisfy { $0.isLetter || $0.isNumber }
    }
    
    private func save(for name: String?) {
        guard let name else { return }
        UserDefaults.standard.set(name, forKey: "USER_NAME")
    }
}
