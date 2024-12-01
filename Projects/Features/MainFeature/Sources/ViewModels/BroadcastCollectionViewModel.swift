import Combine
import UIKit

import BaseFeatureInterface
import BroadcastDomainInterface
import LiveStationDomainInterface
import MainFeatureInterface

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
        let didTapBroadcastPicker: PassthroughSubject<Void, Never> = .init()
    }
    
    public struct Output {
        let channels: PassthroughSubject<[Channel], Never> = .init()
        let showBroadcastUIView: PassthroughSubject<Void, Never> = .init()
        let dismissBroadcastUIView: PassthroughSubject<Void, Never> = .init()
    }
    
    private let output = Output()
    
    private let fetchChannelListUsecase: any FetchChannelListUsecase
    private let fetchAllBroadcastUsecase: any FetchAllBroadcastUsecase
    
    private let broadcastState: BroadcastStateProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    let extensionBundleID = "kr.codesquad.boostcamp9.Shook.BroadcastUploadExtension"
    let isStreamingKey = "IS_STREAMING"
    
    public init(
        fetchChannelListUsecase: FetchChannelListUsecase,
        fetchAllBroadcastUsecase: FetchAllBroadcastUsecase,
        broadcastState: BroadcastStateProtocol = BroadcastState.shared
    ) {
        self.fetchChannelListUsecase = fetchChannelListUsecase
        self.fetchAllBroadcastUsecase = fetchAllBroadcastUsecase
        self.broadcastState = broadcastState
    }
    
    public func transform(input: Input) -> Output {
        input.fetch
            .sink { [weak self] in
                self?.fetchData()
            }
            .store(in: &cancellables)
        
        input.didTapBroadcastPicker
            .sink { [weak self] _ in
                self?.output.showBroadcastUIView.send()
            }
            .store(in: &cancellables)
        
        broadcastState.isBroadcasting
            .sink { [weak self] isBroadcasting in
                if isBroadcasting {
                    self?.output.showBroadcastUIView.send()
                } else {
                    self?.output.dismissBroadcastUIView.send()
                }
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
                        title: broadcast?.title ?? "Unknown",
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
    
    private func loadAsyncImage(with imageURLString: String) -> AnyPublisher<UIImage?, URLError> {
        guard let url = URL(string: imageURLString) else {
            return Just(nil).setFailureType(to: URLError.self).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { data, _ in UIImage(data: data) }
            .eraseToAnyPublisher()
    }
}
