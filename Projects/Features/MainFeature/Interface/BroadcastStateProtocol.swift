import Combine

public protocol BroadcastStateProtocol {
    var isBroadcasting: PassthroughSubject<Bool, Never> { get }
}
