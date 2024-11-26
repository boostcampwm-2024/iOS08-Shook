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
    private let rotator = VideoRotator()
    
    // MARK: - RTMP Service URL and Streaming key
    private let rtmp = "RTMP_SEVICE_URL"
    private let key = "STREAMING_KEY"
    
    override func broadcastStarted(withSetupInfo setupInfo: [String: NSObject]?) {
        Task {
            var videoSettings = VideoCodecSettings()
            videoSettings.videoSize = CGSize(width: 1280, height: 720)
            videoSettings.scalingMode = .letterbox
            
            await stream.setVideoSettings(videoSettings)
            await mixer.addOutput(stream)
            _ = try await connection.connect(rtmp)
            _ = try await stream.publish(key)
        }
        
        sharedDefaults.set(true, forKey: self.isStreamingKey)
    }
    
    override func broadcastFinished() {
        Task {
            _ = try await stream.close()
            try await connection.close()
        }
        
        sharedDefaults.set(false, forKey: isStreamingKey)
    }
    
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        Task {
            switch sampleBufferType {
            case .video:
                if case .success(let rotatedBuffer) = rotator?.rotate(buffer: sampleBuffer) {
                    await mixer.append(rotatedBuffer)
                } else {
                    await mixer.append(sampleBuffer)
                }
                
            case .audioApp:
                await mixer.append(sampleBuffer, track: 0)
                
            case .audioMic:
                await mixer.append(sampleBuffer, track: 1)
                
            default: break
            }
        }
    }
}
