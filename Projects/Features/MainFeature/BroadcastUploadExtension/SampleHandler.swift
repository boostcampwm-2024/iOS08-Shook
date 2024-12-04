import ReplayKit

final class SampleHandler: RPBroadcastSampleHandler, @unchecked Sendable {
    override func broadcastStarted(withSetupInfo _: [String: NSObject]?) {}
}
