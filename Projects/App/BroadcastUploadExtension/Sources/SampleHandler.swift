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
    
    // MARK: - RTMP Service URL and Streaming key
    private let rtmp = "RTMP_SEVICE_URL"
    private let key = "STREAMING_KEY"
    
    override func broadcastStarted(withSetupInfo setupInfo: [String: NSObject]?) {
        Task {
            await mixer.addOutput(stream)
            try await connection.connect(rtmp)
            try await stream.publish(key)
        }
        
        sharedDefaults.set(true, forKey: self.isStreamingKey)
    }
    
    override func broadcastFinished() {
        Task {
            try await stream.close()
            try await connection.close()
        }
        
        sharedDefaults.set(false, forKey: isStreamingKey)
    }
    
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        switch sampleBufferType {
        case .video:
            Task {
                guard let rotator = VideoRotator() else { return }
                let result = rotator.rotate(buffer: sampleBuffer)
                switch result {
                case .success(let rotatedBuffer):
                    await mixer.append(rotatedBuffer)
                
                case .failure(let failure):
                    print("Rotation failed: \(failure)")
                }
            }
            
        case .audioApp:
            Task {
                await mixer.append(sampleBuffer, track: 0)
            }
            
        case .audioMic:
            Task {
                await mixer.append(sampleBuffer, track: 1)
            }
            
        default: break
        }
    }
}
