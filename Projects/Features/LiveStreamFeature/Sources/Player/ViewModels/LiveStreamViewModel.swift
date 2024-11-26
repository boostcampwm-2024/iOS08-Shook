import Combine
import Foundation

import BaseFeatureInterface
import ChattingDomainInterface

public final class LiveStreamViewModel: ViewModel {
    
    private var subscription = Set<AnyCancellable>()
    
    // MARK: - 추후 제거
    let makeChatRoomUseCase: any MakeChatRoomUseCase
    let deleteChatRoomUseCase: any DeleteChatRoomUseCase
        
    public struct Input {
        let expandButtonDidTap: AnyPublisher<Void?, Never>
        let sliderValueDidChange: AnyPublisher<Float?, Never>
        let playerStateDidChange: AnyPublisher<Bool?, Never>
        let playerGestureDidTap: AnyPublisher<Void?, Never>
        let playButtonDidTap: AnyPublisher<Void?, Never>
        let dismissButtonDidTap: AnyPublisher<Void?, Never>
        let chattingSendButtonDidTap: AnyPublisher<ChatInfo?, Never>
        let autoDissmissDidRegister: PassthroughSubject<Void, Never> = .init()
    }
    
    public struct Output {
        let isExpanded: CurrentValueSubject<Bool, Never> = .init(false)
        let isPlaying: CurrentValueSubject<Bool, Never> = .init(false)
        let time: PassthroughSubject<Double, Never> = .init()
        let chatList = CurrentValueSubject<[ChatInfo], Never>([])
        let isShowedPlayerControl: CurrentValueSubject<Bool, Never> = .init(false)
        let isShowedInfoView: CurrentValueSubject<Bool, Never> = .init(false)
        let dismiss: PassthroughSubject<Void, Never> = .init()
    }
    
    public init(makeChatRoomUseCase: any MakeChatRoomUseCase, deleteChatRoomUseCase: any DeleteChatRoomUseCase) {
        self.makeChatRoomUseCase = makeChatRoomUseCase
        self.deleteChatRoomUseCase = deleteChatRoomUseCase
    }
    
    deinit {
        print("Deinit \(Self.self)")
    }
    
    public func transform(input: Input) -> Output {
        let output = Output()
        
        input.expandButtonDidTap
            .compactMap { $0 }
            .sink {
                let nextValue = !output.isExpanded.value
                output.isExpanded.send(nextValue)
                output.isShowedPlayerControl.send(false)
                output.isShowedInfoView.send(false)
            }
            .store(in: &subscription)
        
        input.sliderValueDidChange
            .compactMap { $0 }
            .map { Double($0) }
            .sink {
                input.autoDissmissDidRegister.send()
                output.time.send($0)
            }
            .store(in: &subscription)
        
        input.playerStateDidChange
            .compactMap { $0 }
            .sink { flag in
                output.isPlaying.send(flag)
            }
            .store(in: &subscription)
        
        input.playerGestureDidTap
            .compactMap { $0 }
            .sink { _ in
                let nextValue1 = !output.isShowedPlayerControl.value
                output.isShowedPlayerControl.send(nextValue1)
                
                if nextValue1 {
                    input.autoDissmissDidRegister.send()
                }
                
                if output.isExpanded.value {
                    output.isShowedInfoView.send(false)
                } else {
                    output.isShowedInfoView.send(!output.isShowedInfoView.value)
                }
            }
            .store(in: &subscription)
        
        input.playButtonDidTap
            .compactMap { $0 }
            .sink { _ in
                input.autoDissmissDidRegister.send()
                output.isPlaying.send(!output.isPlaying.value)
            }
            .store(in: &subscription)
        
        input.dismissButtonDidTap
            .sink { _ in
                output.dismiss.send()
            }
            .store(in: &subscription)
        
        input.chattingSendButtonDidTap
            .sink { chatInfo in
             }
             .store(in: &subscription)
      
        input.autoDissmissDidRegister
            .debounce(for: .seconds(3), scheduler: DispatchQueue.main)
            .sink { _ in
                output.isShowedPlayerControl.send(false)
                output.isShowedInfoView.send(false)
            }
            .store(in: &subscription)
        
        return output
    }
    
}
