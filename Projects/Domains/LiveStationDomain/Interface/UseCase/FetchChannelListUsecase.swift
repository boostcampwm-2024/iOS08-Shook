import Combine

public protocol FetchChannelListUsecase {
    func execute() -> AnyPublisher<[ChannelEntity], Error>
}
