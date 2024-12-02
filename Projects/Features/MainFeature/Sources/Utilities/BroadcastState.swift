import Combine

import MainFeatureInterface

public final class BroadcastState: BroadcastStateProtocol {
    public static let shared = BroadcastState()
    
    public let isBroadcasting: PassthroughSubject<Bool, Never> = .init()
    
    private init() {}
}
