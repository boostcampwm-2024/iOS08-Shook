import Combine

import BaseFeatureInterface

public class SignUpViewModel: ViewModel {
    public struct Input {
        let didWriteUserName: PassthroughSubject<String, Never> = .init()
    }
    public struct Output {
        let isValidate: PassthroughSubject<Bool, Never> = .init()
    }
    
    private let output = Output()
    private var cancellables = Set<AnyCancellable>()
    
    public func transform(input: Input) -> Output {
        input.didWriteUserName
            .sink { [weak self] name in
                if let isValidate = self?.validate(with: name) {
                    self?.output.isValidate.send(isValidate)
                }
            }
            .store(in: &cancellables)
        
        return output
    }
    
    public init() { }
    
    private func validate(with name: String) -> Bool {
        name.count >= 2 && name.count <= 10 && name.allSatisfy { $0.isLetter || $0.isNumber }
    }
}
