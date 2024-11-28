import Combine

public protocol DeleteChannelUsecase {
    func execute(channelID: String) -> AnyPublisher<Void, Error>
}
