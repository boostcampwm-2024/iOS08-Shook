import Combine

public protocol FetchVideoListUsecase {
    func execute(channelID: String) -> AnyPublisher<[VideoEntity], Error>
}
