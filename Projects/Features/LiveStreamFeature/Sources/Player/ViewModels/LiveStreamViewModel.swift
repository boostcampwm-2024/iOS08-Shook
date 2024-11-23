import Combine

import BaseFeatureInterface

public final class LiveStreamViewModel: ViewModel {
    
    private var subscription = Set<AnyCancellable>()
    
    public struct Input {
        let expandButtonDidTap: AnyPublisher<Void, Never>
        let sliderValueDidChange: AnyPublisher<Float, Never>
        let playerStateDidChange: AnyPublisher<Bool, Never>
        let playerGestureDidTap: AnyPublisher<Void, Never>
        let playButtonDidTap: AnyPublisher<Void, Never>
        let chatingSendButtonDidTap: AnyPublisher<ChatInfo?, Never>
    }
    
    public struct Output {
        let isExpanded: CurrentValueSubject<Bool, Never> = .init(false)
        let isPlaying: CurrentValueSubject<Bool, Never> = .init(false)
        let time: PassthroughSubject<Double, Never> = .init()
        let isplayerControlShowed: CurrentValueSubject<Bool, Never> = .init(false)
        let chatList = CurrentValueSubject<[ChatInfo], Never>([])
    }
    
    public init() {}
    
    public func transform(input: Input) -> Output {
        let output = Output()
        
        input.expandButtonDidTap
            .sink {
                output.isExpanded.send(!output.isExpanded.value)
                output.isplayerControlShowed.send(false)
            }
            .store(in: &subscription)
        
        input.sliderValueDidChange
            .compactMap { Double($0) }
            .sink {
                output.time.send($0)
            }
            .store(in: &subscription)
        
        input.playerStateDidChange
            .sink { flag in
                output.isPlaying.send(flag)
            }
            .store(in: &subscription)
        
        input.playerGestureDidTap
            .sink { _ in
                output.isplayerControlShowed.send(!output.isplayerControlShowed.value)
            }
            .store(in: &subscription)
                
        input.playButtonDidTap
            .sink { _ in
                output.isPlaying.send(!output.isPlaying.value)
            }
            .store(in: &subscription)
        
        input.chatingSendButtonDidTap
            .sink { chatInfo in
            }
            .store(in: &subscription)
        
        return output
    }
    
}
