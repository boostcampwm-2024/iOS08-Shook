import Combine

public protocol CreateChannelUsecase {
    func execute(name: String) -> AnyPublisher<ChannelEntity, Error>
}
