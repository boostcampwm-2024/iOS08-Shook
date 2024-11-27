import Combine
import Foundation

import BaseFeatureInterface
import ChatSoketModule
import ChattingDomainInterface
import LiveStationDomainInterface

public final class LiveStreamViewModel: ViewModel {
    
    private var subscription = Set<AnyCancellable>()
    
    private let chattingSocket: WebSocket
    private let channelID: String
    let fetchVideoListUsecase: any FetchVideoListUsecase
    
    private let output = Output()
    
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
        let videoURLString: PassthroughSubject<String, Never> = .init()
    }
    
    public init(
        channelID: String,
        chattingSocket: WebSocket = .shared,
        fetchVideoListUsecase: any FetchVideoListUsecase
    ) {
        self.channelID = channelID
        self.fetchVideoListUsecase = fetchVideoListUsecase
        self.chattingSocket = chattingSocket
    }
    
    deinit {
        print("Deinit \(Self.self)")
        chattingSocket.closeWebSocket()
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
        
        input.viewDidLoad
            .sink { [weak self] _ in
                guard let self else { return }
                fetchVideoData(channelID: channelID)
                openChattingSocket(output: output)
                sendEntryMessage()
                receciveChatMessage(output: output)
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
                        sender: chatInfo.owner.name,
                        roomId: channelID
                    )
                )
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
        fetchVideoListUsecase.execute(channelID: channelID)
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

private extension LiveStreamViewModel {
    func openChattingSocket(output: Output) {
        do {
            try chattingSocket.openWebSocket()
        } catch {
            #warning("에러처리")
        }
    }
    
    func sendEntryMessage() {
        guard let userName = UserDefaults.standard.string(forKey: "USER_NAME") else { return }
        chattingSocket.send(
            data: ChatMessage(
                type: .ENTER,
                content: nil,
                sender: userName,
                roomId: channelID
            )
        )
    }
    
    func receciveChatMessage(output: Output) {
        chattingSocket.receive { chatMessage in
            guard let chatMessage else { return }
            var chatList = output.chatList.value
            if chatMessage.type == .CHAT {
                chatList.append(ChatInfo(owner: .user(name: chatMessage.sender), message: chatMessage.content ?? ""))
            } else {
                chatList.append(ChatInfo(owner: .system, message: chatMessage.content ?? ""))
            }
            output.chatList.send(chatList)
        }
    }
}
