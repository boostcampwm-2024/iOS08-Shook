import ReplayKit

import HaishinKit

final class SampleHandler: RPBroadcastSampleHandler {
    // MARK: - App group
    private let sharedDefaults = UserDefaults(suiteName: "group.kr.codesquad.boostcamp9.Shook")!
    private let isStreamingKey = "isStreaming"
    
    // MARK: - HaishinKit
    private let mixer = MediaMixer()
    private let connection = RTMPConnection()
    private lazy var stream = RTMPStream(connection: connection)
    
    // MARK: - RTMP and Key
    private let rtmp = "RTMP_SERVER_URL"
    private let key = "STREAMING_KEY"
    
    override func broadcastStarted(withSetupInfo setupInfo: [String: NSObject]?) {
        Task {
            try await setStream()
            try await setMixer()
            try await startStreaming()
            
            self.sharedDefaults.set(true, forKey: self.isStreamingKey)
        }
    }
    
    override func broadcastFinished() {
        Task {
            try await endStreaming()
            
            sharedDefaults.set(false, forKey: isStreamingKey)
        }
    }
    
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        Task {
            await appendToMixer(by: sampleBuffer)
        }
    }
}

// MARK: - Methods
extension SampleHandler {
    private func setStream() async throws {
        await stream.setVideoInputBufferCounts(5)
    }
    
    private func setMixer() async throws {
        try await mixer.attachAudio(AVCaptureDevice.default(for: .audio))
        await mixer.addOutput(stream)
    }
    
    private func startStreaming() async throws {
        try await connection.connect(rtmp)
        try await stream.publish(key)
    }
    
    private func endStreaming() async throws {
        try await stream.close()
        try await connection.close()
    }
    
    private func appendToMixer(by sampleBuffer: CMSampleBuffer) async {
        if CMSampleBufferIsValid(sampleBuffer) {
            await mixer.append(sampleBuffer)
        }
    }
}
