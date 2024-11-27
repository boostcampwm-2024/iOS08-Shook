import Combine

public protocol FetchChannelInfoUsecase {
    func execute(channelID: String) -> AnyPublisher<ChannelInfoEntity, any Error>
}
