import Combine
import Foundation

import BaseFeatureInterface
import DesignSystem

final public class SettingViewModel: ViewModel {
    /// Input of SettingViewModel
    public struct Input {
        let didWriteStreamingName: PassthroughSubject<String, Never>
    }
    
    /// Output of SettingViewModel
    public struct Output {
        let isActive: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    }
    
    public init() {}
    
    @Published var streamingName: String = ""    
    private let output = Output()
    private var cancellables = Set<AnyCancellable>()
    
    public func transform(input: Input) -> Output {
        input.didWriteStreamingName
            .sink { [weak self] name in
                guard let self else { return }
                self.streamingName = name
                self.output.isActive.send(valid(name))
            }
            .store(in: &cancellables)
        
        return output
    }
    
    /// 방송 이름이 유효한지 확인하는 메서드
    /// - Parameter _: 방송 이름
    /// - Returns: 유효하면 true
    func valid(_ value: String) -> Bool {
        3...20 ~= value.count
    }
}
