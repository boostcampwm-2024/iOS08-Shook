import Combine
import Foundation

import BaseFeatureInterface
import DesignSystem

public final class SettingViewModel: ViewModel {
    /// Input of SettingViewModel
    public struct Input {
        let didWriteStreamingName: PassthroughSubject<String, Never> = .init()
    }
    
    /// Output of SettingViewModel
    public struct Output {
        let isActive: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
        let errorMessage: PassthroughSubject<String?, Never> = PassthroughSubject()
    }
    
    public init() {}
    
    private let output = Output()
    private var cancellables = Set<AnyCancellable>()
    
    public func transform(input: Input) -> Output {
        input.didWriteStreamingName
            .sink { [weak self] name in
                guard let self else { return }
                let validness = valid(name)
                self.output.isActive.send(validness.isValid)
                self.output.errorMessage.send(validness.errorMessage)
            }
            .store(in: &cancellables)
        
        return output
    }
    
    /// 방송 이름이 유효한지 확인하는 메서드
    /// - Parameter _:  방송 이름
    /// - Returns: (Bool, String?) - 유효 여부와 에러 메시지
    private func valid(_ value: String) -> (isValid: Bool, errorMessage: String?) {
        let isLengthValid = 3...20 ~= value.count
        let isCharactersValid = value.allSatisfy { $0.isLetter || $0.isNumber || $0 == "_" }
        
        if !isLengthValid && !isCharactersValid {
            return (false, "3글자 이상,20글자 이하로 입력해 주세요. 특수문자는 언더바(_)만 가능합니다.")
        } else if !isLengthValid {
            return (false, "최소 3글자 이상, 최대 20글자 이하로 입력해 주세요.")
        } else if !isCharactersValid {
            return (false, "특수문자는 언더바(_)만 가능합니다.")
        } else {
            return (true, nil)
        }
    }
}
