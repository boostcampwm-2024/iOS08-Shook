import Combine
import UIKit

import BaseFeatureInterface
import BroadcastDomainInterface
import LiveStationDomainInterface
import MainFeatureInterface

public class BroadcastCollectionViewModel: ViewModel {
    public struct Input {
        let fetch: PassthroughSubject<Void, Never> = .init()
    }
    
    public struct Output {
        let channels: PassthroughSubject<[Channel], Never> = .init()
    }
    
    private let output = Output()
    
    private let fetchChannelListUsecase: any FetchChannelListUsecase
    private let fetchAllBroadcastUsecase: any FetchAllBroadcastUsecase
        
    private var cancellables = Set<AnyCancellable>()
    
    private let extensionBundleID = "kr.codesquad.boostcamp9.Shook.BroadcastUploadExtension"
    private let isStreamingKey = "IS_STREAMING"
    private let channelID = UserDefaults.standard.string(forKey: "CHANNEL_ID")
    
    public init(
        fetchChannelListUsecase: FetchChannelListUsecase,
        fetchAllBroadcastUsecase: FetchAllBroadcastUsecase
    ) {
        self.fetchChannelListUsecase = fetchChannelListUsecase
        self.fetchAllBroadcastUsecase = fetchAllBroadcastUsecase
    }
    
    public func transform(input: Input) -> Output {
        input.fetch
            .sink { [weak self] in
                self?.fetchData()
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
                receiveCompletion: { _ in },
                receiveValue: { [weak self] channels in
                    let filteredChannels = channels.filter { !($0.id == self?.channelID) }
                    self?.output.channels.send(filteredChannels)
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
