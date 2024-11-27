import Combine
import Foundation

import BaseFeatureInterface
import ChattingDomainInterface
import LiveStationDomainInterface

public final class LiveStreamViewModel: ViewModel {
    
    private var subscription = Set<AnyCancellable>()
    
    // MARK: - 추후 제거
    let makeChatRoomUseCase: any MakeChatRoomUseCase
    let deleteChatRoomUseCase: any DeleteChatRoomUseCase
    let fetchBroadcastUseCase: any FetchVideoListUsecase
    
    private let output = Output()

    public struct Input {
        let expandButtonDidTap: AnyPublisher<Void?, Never>
        let sliderValueDidChange: AnyPublisher<Float?, Never>
        let playerStateDidChange: AnyPublisher<Bool?, Never>
        let playerGestureDidTap: AnyPublisher<Void?, Never>
        let playButtonDidTap: AnyPublisher<Void?, Never>
        let dismissButtonDidTap: AnyPublisher<Void?, Never>
        let chatingSendButtonDidTap: AnyPublisher<ChatInfo?, Never>
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
        let videoURLString: PassthroughSubject<String, Never> = .init()
    }
    
    public init(
        makeChatRoomUseCase: any MakeChatRoomUseCase,
        deleteChatRoomUseCase: any DeleteChatRoomUseCase,
        fetchBroadcastUseCase: any FetchVideoListUsecase,
        channelID: String
    ) {
        self.makeChatRoomUseCase = makeChatRoomUseCase
        self.deleteChatRoomUseCase = deleteChatRoomUseCase
        self.fetchBroadcastUseCase = fetchBroadcastUseCase
        fetchVideoData(channelID: channelID)
    }
    
    deinit {
        print("Deinit \(Self.self)")
    }
    
    public func transform(input: Input) -> Output {
        input.expandButtonDidTap
            .compactMap { $0 }
            .sink {
                let nextValue = !self.output.isExpanded.value
                self.output.isExpanded.send(nextValue)
                self.output.isShowedPlayerControl.send(false)
                self.output.isShowedInfoView.send(false)
            }
            .store(in: &subscription)
        
        input.sliderValueDidChange
            .compactMap { $0 }
            .map { Double($0) }
            .sink {
                input.autoDissmissDidRegister.send()
                self.output.time.send($0)
            }
            .store(in: &subscription)
        
        input.playerStateDidChange
            .compactMap { $0 }
            .sink { flag in
                self.output.isPlaying.send(flag)
            }
            .store(in: &subscription)
        
        input.playerGestureDidTap
            .compactMap { $0 }
            .sink { _ in
                let nextValue1 = !self.output.isShowedPlayerControl.value
                self.output.isShowedPlayerControl.send(nextValue1)
                
                if nextValue1 {
                    input.autoDissmissDidRegister.send()
                }
                
                if self.output.isExpanded.value {
                    self.output.isShowedInfoView.send(false)
                } else {
                    self.output.isShowedInfoView.send(!self.output.isShowedInfoView.value)
                }
            }
            .store(in: &subscription)
        
        input.playButtonDidTap
            .compactMap { $0 }
            .sink { _ in
                input.autoDissmissDidRegister.send()
                self.output.isPlaying.send(!self.output.isPlaying.value)
            }
            .store(in: &subscription)
        
        input.dismissButtonDidTap
            .sink { _ in
                self.output.dismiss.send()
            }
            .store(in: &subscription)
        
        input.chatingSendButtonDidTap
            .sink { chatInfo in
             }
             .store(in: &subscription)
      
        input.autoDissmissDidRegister
            .debounce(for: .seconds(3), scheduler: DispatchQueue.main)
            .sink { _ in
                self.output.isShowedPlayerControl.send(false)
                self.output.isShowedInfoView.send(false)
            }
            .store(in: &subscription)
        
        return output
    }
    
    private func fetchVideoData(channelID: String) {
        fetchBroadcastUseCase.execute(channelID: channelID)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { entityList in
                    let entity = entityList.filter { $0.name == "ABR" }.first
                    if let entity {
                        return self.output.videoURLString.send(entity.videoURLString)
                    } else if let lowResolution = entityList.first?.videoURLString {
                        return self.output.videoURLString.send(lowResolution)
                    }
                    })
            .store(in: &subscription)
    }
}
