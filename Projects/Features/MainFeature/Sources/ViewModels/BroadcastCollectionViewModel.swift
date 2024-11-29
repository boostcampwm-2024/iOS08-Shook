import Combine
import UIKit

import BaseFeatureInterface
import BroadcastDomainInterface
import LiveStationDomainInterface

public struct Channel: Hashable {
    let id: String
    let name: String
    var thumbnailImageURLString: String
    var thumbnailImage: UIImage?
    let owner: String
    let description: String

    public init(
        id: String,
        title: String,
        thumbnailImageURLString: String = "",
        thumbnailImage: UIImage? = nil,
        owner: String = "",
        description: String = ""
    ) {
        self.id = id
        self.name = title
        self.thumbnailImageURLString = thumbnailImageURLString
        self.thumbnailImage = thumbnailImage
        self.owner = owner
        self.description = description
    }
}

public class BroadcastCollectionViewModel: ViewModel {
    public struct Input {
        let fetch: PassthroughSubject<Void, Never> = .init()
        let didWriteStreamingName: PassthroughSubject<String, Never> = .init()
        let didWriteStreamingDescription: PassthroughSubject<String, Never> = .init()
        let didTapBroadcastButton: PassthroughSubject<Void, Never> = .init()
        let didTapFinishStreamingButton: PassthroughSubject<Void, Never> = .init()
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
    private let deleteChannelUsecase: any DeleteChannelUsecase
    private let fetchChannelInfoUsecase: any FetchChannelInfoUsecase
    private let makeBroadcastUsecase: any MakeBroadcastUsecase
    private let fetchAllBroadcastUsecase: any FetchAllBroadcastUsecase
    private let deleteBroadCastUsecase: any DeleteBroadcastUsecase
    
    private var cancellables = Set<AnyCancellable>()
    
    let sharedDefaults = UserDefaults(suiteName: "group.kr.codesquad.boostcamp9.Shook")!
    let isStreamingKey = "isStreaming"
    private let rtmp = "RTMP_SEVICE_URL"
    private let streamKey = "STREAMING_KEY"
    let extensionBundleID = "kr.codesquad.boostcamp9.Shook.BroadcastUploadExtension"
    
    private let userName = UserDefaults.standard.string(forKey: "USER_NAME") ?? ""
    private var channelName: String = ""
    private var channelDescription: String = ""
    private var channel: ChannelEntity?

    public init(
        fetchChannelListUsecase: FetchChannelListUsecase,
        createChannelUsecase: CreateChannelUsecase,
        deleteChannelUsecase: DeleteChannelUsecase,
        fetchChannelInfoUsecase: FetchChannelInfoUsecase,
        makeBroadcastUsecase: MakeBroadcastUsecase,
        fetchAllBroadcastUsecase: FetchAllBroadcastUsecase,
        deleteBroadCastUsecase: DeleteBroadcastUsecase
    ) {
        self.fetchChannelListUsecase = fetchChannelListUsecase
        self.createChannelUsecase = createChannelUsecase
        self.deleteChannelUsecase = deleteChannelUsecase
        self.fetchChannelInfoUsecase = fetchChannelInfoUsecase
        self.makeBroadcastUsecase = makeBroadcastUsecase
        self.fetchAllBroadcastUsecase = fetchAllBroadcastUsecase
        self.deleteBroadCastUsecase = deleteBroadCastUsecase
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
        
        input.didWriteStreamingDescription
            .sink { [weak self] description in
                self?.channelDescription = description
            }
            .store(in: &cancellables)
        
        input.didTapBroadcastButton
            .sink { [weak self] _ in
                self?.output.showBroadcastUIView.send()
            }
            .store(in: &cancellables)
        
        input.didTapFinishStreamingButton
            .flatMap { [weak self] _ in
                guard let self, let channel else { return Empty<(Void, Void), Error>().eraseToAnyPublisher() }
                return deleteChannelUsecase.execute(channelID: channel.id)
                    .zip(deleteBroadCastUsecase.execute(id: channel.id))
                    .eraseToAnyPublisher()
            }
            .sink { _ in
            } receiveValue: { [weak self] _ in
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
                guard let self else { return Empty<ChannelInfoEntity, Error>().eraseToAnyPublisher() }
                channel = $0
                return fetchChannelInfoUsecase.execute(channelID: $0.id)
                    .zip(makeBroadcastUsecase.execute(id: $0.id, title: $0.name, owner: userName, description: channelDescription))
                    .map { channelInfo, _ in channelInfo }
                    .eraseToAnyPublisher()
            }
            .sink { _ in
            } receiveValue: { [weak self] channelInfo in
                guard let self else { return }
                sharedDefaults.set(channelInfo.rtmpUrl, forKey: rtmp)
                sharedDefaults.set(channelInfo.streamKey, forKey: streamKey)
                output.isReadyToStream.send(true)
            }
            .store(in: &cancellables)

        return output
    }
    
    private func fetchData() {
        fetchChannelListUsecase.execute()
            .zip(fetchAllBroadcastUsecase.execute())
            .map { channelEntities, broadcastInfoEntities -> [Channel] in
                channelEntities.map { channelEntity in
                    let broadcast = broadcastInfoEntities.first { $0.id == channelEntity.id }
                    return Channel(
                        id: channelEntity.id,
                        title: channelEntity.name,
                        thumbnailImageURLString: channelEntity.imageURLString,
                        owner: broadcast?.owner ?? "Unknown",
                        description: broadcast?.description ?? ""
                    )
                }
            }
            .flatMap { [weak self] channels -> AnyPublisher<[Channel], Never> in
                guard let self else { return Just([]).eraseToAnyPublisher() }

                return channels.publisher
                    .flatMap { channel -> AnyPublisher<Channel, Never> in
                        self.loadAsyncImage(with: channel.thumbnailImageURLString)
                            .replaceError(with: nil)
                            .map { image in
                                var updatedChannel = channel
                                updatedChannel.thumbnailImage = image
                                return updatedChannel
                            }
                            .eraseToAnyPublisher()
                    }
                    .collect()
                    .eraseToAnyPublisher()
            }
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error): print("Error: \(error)")
                    }
                },
                receiveValue: { [weak self] channels in
                    self?.output.channels.send(channels)
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
    
    private func loadAsyncImage(with imageURLString: String) -> AnyPublisher<UIImage?, URLError> {
        guard let url = URL(string: imageURLString) else {
            return Just(nil).setFailureType(to: URLError.self).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { data, _ in UIImage(data: data) }
            .eraseToAnyPublisher()
    }
}