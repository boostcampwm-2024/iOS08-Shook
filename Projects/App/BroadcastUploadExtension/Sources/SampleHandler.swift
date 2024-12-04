import ReplayKit

import HaishinKit

final class SampleHandler: RPBroadcastSampleHandler {
    // MARK: - App group

    private let sharedDefaults = UserDefaults(suiteName: "group.kr.codesquad.boostcamp9.Shook")!
    private let isStreamingKey = "IS_STREAMING"

    // MARK: - HaishinKit

    private let mixer = MediaMixer()
    private let connection = RTMPConnection()
    private lazy var stream = RTMPStream(connection: connection)
    private let rotator = VideoRotator()

    // MARK: - RTMP Service URL and Streaming key

    private let rtmp = "RTMP_SEVICE_URL"
    private let streamKey = "STREAMING_KEY"

    override func broadcastStarted(withSetupInfo _: [String: NSObject]?) {
        Task {
            var videoSettings = VideoCodecSettings()
            videoSettings.videoSize = CGSize(width: 1280, height: 720)
            videoSettings.scalingMode = .letterbox

            await stream.setVideoSettings(videoSettings)
            await mixer.addOutput(stream)

            guard let rtmpURL = sharedDefaults.string(forKey: rtmp),
                  let streamKey = sharedDefaults.string(forKey: streamKey) else { return }

            _ = try await connection.connect(rtmpURL)
            _ = try await stream.publish(streamKey)
        }

        sharedDefaults.set(true, forKey: isStreamingKey)
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
                if case let .success(rotatedBuffer) = rotator?.rotate(buffer: sampleBuffer) {
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
