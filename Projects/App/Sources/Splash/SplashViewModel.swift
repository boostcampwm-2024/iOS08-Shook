import Combine

import BaseFeatureInterface

public final class SplashViewModel: ViewModel {
    public struct Input {
        let viewDidLoad: AnyPublisher<Void?, Never>
    }
    
    public struct Output {
        let isRunnigAnimation =  PassthroughSubject<Bool, Never>()
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    public init() { }
    
    public func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .compactMap { $0 }
            .sink { _ in
                output.isRunnigAnimation.send(true)
            }
            .store(in: &subscriptions)
        
        return output
    }
}
