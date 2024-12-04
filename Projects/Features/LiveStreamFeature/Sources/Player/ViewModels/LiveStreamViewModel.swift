import Combine
import Foundation

import BaseFeatureInterface
import ChatSoketModule
import LiveStationDomainInterface

// MARK: - LiveStreamViewModel

public final class LiveStreamViewModel: ViewModel {
    private var subscription = Set<AnyCancellable>()

    private let chattingSocket: WebSocket
    private let channelID: String
    private let fetchVideoListUsecase: any FetchVideoListUsecase

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
        let showAlert: PassthroughSubject<Void, Never> = .init()
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
                fetchVideoData(output: output, channelID: channelID)
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
                output.isShowedPlayerControl.send(false)
                output.isShowedInfoView.send(false)
            }
            .store(in: &subscription)

        return output
    }

    private func fetchVideoData(output: Output, channelID: String) {
        fetchVideoListUsecase.execute(channelID: channelID)
            .sink(
                receiveCompletion: { commpletion in
                    switch commpletion {
                    case .failure:
                        output.showAlert.send(())

                    case .finished:
                        break
                    }
                },
                receiveValue: { entityList in
                    let entity = entityList.filter { $0.name == "ABR" }.first
                    if let entity {
                        return output.videoURLString.send(entity.videoURLString)
                    } else if let lowResolution = entityList.first?.videoURLString {
                        return output.videoURLString.send(lowResolution)
                    }
                }
            )
            .store(in: &subscription)
    }
}

private extension LiveStreamViewModel {
    func openChattingSocket(output _: Output) {
        do {
            try chattingSocket.openWebSocket()
        } catch {
            chattingSocket.send(data: ChatMessage(
                type: .TERMINATE,
                content: "채팅 연결이 끊겼습니다.",
                sender: "SYSTEM",
                roomId: channelID
            )
            )
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
