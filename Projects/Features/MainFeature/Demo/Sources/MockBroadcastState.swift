import Combine

import MainFeatureInterface

final class MockBroadcastState: BroadcastStateProtocol {
    var isBroadcasting: PassthroughSubject<Bool, Never> = .init()
}
