import ReplayKit

class SampleHandler: RPBroadcastSampleHandler {
    private let sharedDefaults = UserDefaults(suiteName: "group.kr.codesquad.boostcamp9.Shook")!
    private let isStreamingKey = "isStreaming"
    
    override func broadcastStarted(withSetupInfo setupInfo: [String: NSObject]?) {
        self.sharedDefaults.set(true, forKey: self.isStreamingKey)
        
    }
    
    override func broadcastFinished() {
        sharedDefaults.set(false, forKey: isStreamingKey)
    }
    
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
    }
}
