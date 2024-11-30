import Combine

final class BroadcastState {
    static let shared = BroadcastState()
    
    let isBroadcasting: PassthroughSubject<Bool, Never> = .init()
}
