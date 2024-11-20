import Combine

import BaseFeatureInterface

public final class LiveStreamViewModel: ViewModel {
    
    private var subscription = Set<AnyCancellable>()
    
    public struct Input {
        let expandButtonDidTap: AnyPublisher<Void, Never>
    }
    
    public struct Output {
        let isExpanded: CurrentValueSubject<Bool, Never> = .init(false)
    }
    
    public init() {}
    
    public func transform(input: Input) -> Output {
        let output = Output()
        
        input.expandButtonDidTap.sink {
            output.isExpanded.send(!output.isExpanded.value)
        }
        .store(in: &subscription)
        
        return output
    }
    
}
