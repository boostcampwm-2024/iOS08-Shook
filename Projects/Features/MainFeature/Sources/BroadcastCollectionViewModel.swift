import Combine
import UIKit

import BaseFeatureInterface
import ChattingDomainInterface
import LiveStationDomainInterface

public struct Channel: Hashable {
    let id: String
    let name: String
    let thumbnailImageURLString: String
    
    public init(id: String, title: String, imageURLString: String) {
        self.id = id
        self.name = title
        self.thumbnailImageURLString = imageURLString
    }
}

public class BroadcastCollectionViewModel: ViewModel {
    public struct Input {
        let fetch: PassthroughSubject<Void, Never> = .init()
        let didWriteStreamingName: PassthroughSubject<String, Never> = .init()
        let didTapBroadcastButton: PassthroughSubject<Void, Never> = .init()
        let didTapEndStreamingButton: PassthroughSubject<Void, Never> = .init()
        let didTapStartBroadcastButton: PassthroughSubject<Void, Never> = .init()
    }
    
    public struct Output {
        let channels: PassthroughSubject<[Channel], Never> = .init()
        let streamingStartButtonIsActive: PassthroughSubject<Bool, Never> = .init()
        let errorMessage: PassthroughSubject<String?, Never> = .init()
        let showBroadcastUIView: PassthroughSubject<Void, Never> = .init()
        let dismissBroadcastUIView: PassthroughSubject<Void, Never> = .init()
        let isReadyToStream: PassthroughSubject<Bool, Never> = .init()
    }
    
    private let output = Output()
    
    private let fetchChannelListUsecase: any FetchChannelListUsecase
    private let createChannelUsecase: any CreateChannelUsecase
    private let fetchChannelInfoUsecase: any FetchChannelInfoUsecase
    private let makeChatRoomUsecase: any MakeChatRoomUseCase
    
    private var cancellables = Set<AnyCancellable>()
    
    let sharedDefaults = UserDefaults(suiteName: "group.kr.codesquad.boostcamp9.Shook")!
    let isStreamingKey = "isStreaming"
    let extensionBundleID = "kr.codesquad.boostcamp9.Shook.BroadcastUploadExtension"
    
    private var channelName: String = ""

    public init(
        fetchChannelListUsecase: FetchChannelListUsecase,
        createChannelUsecase: CreateChannelUsecase,
        fetchChannelInfoUsecase: FetchChannelInfoUsecase,
        makeChatRoomUsecase: MakeChatRoomUseCase
    ) {
        self.fetchChannelListUsecase = fetchChannelListUsecase
        self.createChannelUsecase = createChannelUsecase
        self.fetchChannelInfoUsecase = fetchChannelInfoUsecase
        self.makeChatRoomUsecase = makeChatRoomUsecase
    }
    
    public func transform(input: Input) -> Output {
        input.fetch
            .sink { [weak self] in
                self?.fetchData()
            }
            .store(in: &cancellables)
       
        input.didWriteStreamingName
            .sink { [weak self] name in
                guard let self else { return }
                let validness = valid(name)
                self.output.streamingStartButtonIsActive.send(validness.isValid)
                self.output.errorMessage.send(validness.errorMessage)
                if validness.isValid {
                    channelName = name
                }
            }
            .store(in: &cancellables)
        
        input.didTapBroadcastButton
            .sink { [weak self] _ in
                self?.output.showBroadcastUIView.send()
            }
            .store(in: &cancellables)
        
        input.didTapEndStreamingButton
            .sink { [weak self] _ in
                self?.output.dismissBroadcastUIView.send()
            }
            .store(in: &cancellables)
        
        input.didTapStartBroadcastButton
            .flatMap { [weak self] _ in
                guard let self else { return Empty<ChannelEntity, Error>().eraseToAnyPublisher() }
                output.isReadyToStream.send(false)
                return createChannelUsecase.execute(name: channelName)
                    
            }
            .flatMap { [weak self] in
                guard let self else { return Empty<(ChannelInfoEntity, Void), Error>().eraseToAnyPublisher() }
                return fetchChannelInfoUsecase.execute(channelID: $0.id)
                    .zip(makeChatRoomUsecase.execute(id: $0.id))
                    .eraseToAnyPublisher()
            }
            .sink { _ in
            } receiveValue: { [weak self] (channelInfo) in
                self?.output.isReadyToStream.send(true)
            }
            .store(in: &cancellables)

        return output
    }
    
    private func fetchData() {
        fetchChannelListUsecase.execute()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { entity in
                    self.output.channels.send(entity.map {
                        Channel(id: $0.id, title: $0.name, imageURLString: $0.imageURLString)
                    })
                }
            )
            .store(in: &cancellables)
    }
    
    /// 방송 이름이 유효한지 확인하는 메서드
    /// - Parameter _:  방송 이름
    /// - Returns: (Bool, String?) - 유효 여부와 에러 메시지
    private func valid(_ value: String) -> (isValid: Bool, errorMessage: String?) {
        let isLengthValid = 3...20 ~= value.count
        let isCharactersValid = value.allSatisfy { $0.isLetter || $0.isNumber || $0 == "_" }
        
        if !isLengthValid && !isCharactersValid {
            return (false, "3글자 이상,20글자 이하로 입력해 주세요. 특수문자는 언더바(_)만 가능합니다.")
        } else if !isLengthValid {
            return (false, "최소 3글자 이상, 최대 20글자 이하로 입력해 주세요.")
        } else if !isCharactersValid {
            return (false, "특수문자는 언더바(_)만 가능합니다.")
        } else {
            return (true, nil)
        }
    }
}
