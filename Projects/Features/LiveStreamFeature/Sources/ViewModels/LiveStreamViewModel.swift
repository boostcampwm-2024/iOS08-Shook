import Combine

import BaseFeatureInterface

public final class LiveStreamViewModel: ViewModel {
    
    private var subscription = Set<AnyCancellable>()
    
    public struct Input {
        let expandButtonDidTap: AnyPublisher<Void, Never>
        let sliderValueDidChange: AnyPublisher<Float, Never>
    }
    
    public struct Output {
        let isExpanded: CurrentValueSubject<Bool, Never> = .init(false)
        let time: PassthroughSubject<Double, Never> = .init()
    }
    
    public init() {}
    
    public func transform(input: Input) -> Output {
        let output = Output()
        
        input.expandButtonDidTap
            .sink {
                output.isExpanded.send(!output.isExpanded.value)
            }
            .store(in: &subscription)
        
        input.sliderValueDidChange
            .compactMap { Double($0) }
            .sink(receiveValue: {
                output.time.send($0)
            })
            .store(in: &subscription)
        
        return output
    }
    
}
