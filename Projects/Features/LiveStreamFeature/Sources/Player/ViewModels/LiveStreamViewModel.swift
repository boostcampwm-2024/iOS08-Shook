import Combine
import Foundation

import BaseFeatureInterface
import ChatSoketModule
import ChattingDomainInterface

public final class LiveStreamViewModel: ViewModel {
    
    private var subscription = Set<AnyCancellable>()
    
    private let chattingSocket: WebSocket
    
    private let channelID: String
        
    public struct Input {
        let expandButtonDidTap: AnyPublisher<Void?, Never>
        let sliderValueDidChange: AnyPublisher<Float?, Never>
        let playerStateDidChange: AnyPublisher<Bool?, Never>
        let playerGestureDidTap: AnyPublisher<Void?, Never>
        let playButtonDidTap: AnyPublisher<Void?, Never>
        let dismissButtonDidTap: AnyPublisher<Void?, Never>
        let chattingSendButtonDidTap: AnyPublisher<ChatInfo?, Never>
        let autoDissmissDidRegister: PassthroughSubject<Void, Never> = .init()
        let viewDidLoad: AnyPublisher<Void, Never>
    }
    
    public struct Output {
        let isExpanded: CurrentValueSubject<Bool, Never> = .init(false)
        let isPlaying: CurrentValueSubject<Bool, Never> = .init(false)
        let time: PassthroughSubject<Double, Never> = .init()
        let chatList = CurrentValueSubject<[ChatInfo], Never>([])
        let isShowedPlayerControl: CurrentValueSubject<Bool, Never> = .init(false)
        let isShowedInfoView: CurrentValueSubject<Bool, Never> = .init(false)
        let dismiss: PassthroughSubject<Void, Never> = .init()
        let error: CurrentValueSubject<Error?, Never> = .init(nil)
    }
    
    public init(
        channelID: String,
        chattingSocket: WebSocket = .shared
    ) {
        self.channelID = channelID
        self.chattingSocket = chattingSocket
    }
    
    deinit {
        print("Deinit \(Self.self)")
        chattingSocket.closeWebSocket()
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
        
        input.viewDidLoad
            .sink { [weak self] _ in
                guard let self else { return }
                
                do {
                    try chattingSocket.openWebSocket()
                } catch {
                    output.error.send(error)
                }
                
                chattingSocket.send(
                    data: ChatMessage(
                        type: .ENTER,
                        content: "XXX님이 입장하셨습니다.",
                        sender: channelID,
                        roomId: channelID
                    )
                )
                
                chattingSocket.receive { chatMessage in
                    guard let chatMessage else { return }
                    var chatList = output.chatList.value
                    chatList.append(ChatInfo(name: chatMessage.sender, message: chatMessage.content ?? ""))
                    output.chatList.send(chatList)
                }
            }
            .store(in: &subscription)
        
        input.chattingSendButtonDidTap
            .sink { [weak self] chatInfo in
                guard let chatInfo,
                      let self else { return }
                chattingSocket.send(
                    data: ChatMessage(
                        type: .CHAT,
                        content: chatInfo.message,
                        sender: chatInfo.name,
                        roomId: channelID
                    )
                )
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
