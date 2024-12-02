import Combine
import UIKit

import BaseFeatureInterface
import BroadcastDomainInterface
import LiveStationDomainInterface
import MainFeatureInterface

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
    
    private let extensionBundleID = "kr.codesquad.boostcamp9.Shook.BroadcastUploadExtension"
    private let isStreamingKey = "IS_STREAMING"
    private let channelID = UserDefaults.standard.string(forKey: "CHANNEL_ID")
    
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
            .map { channelEntities, broadcastInfoEntities in
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
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] channels in
                    let filteredChannels = channels.filter { !($0.id == self?.channelID) }
                    self?.output.channels.send(filteredChannels)
                }
            )
            .store(in: &cancellables)
    }
}
