//
//  SampleHandler.swift
//  BroadcastUpload
//
//  Created by hyunjun on 11/6/24.
//

import Logboard
import ReplayKit

final class SampleHandler: RPBroadcastSampleHandler, @unchecked Sendable {
    private let mixer = MediaMixer(multiCamSessionEnabled: false, multiTrackAudioMixingEnabled: true)
    private let connection = RTMPConnection()
    private lazy var stream = RTMPStream(connection: connection)

    override func broadcastStarted(withSetupInfo setupInfo: [String: NSObject]?) {
        Task {
            do {
                /// stream, mixer 설정
                await stream.setVideoInputBufferCounts(5)
                await mixer.setVideoRenderingMode(.passthrough)
                try await mixer.attachAudio(AVCaptureDevice.default(for: .audio))
                
                await mixer.addOutput(stream)
                
                /// connection, stream 연결 및 배포
                try await connection.connect("{rtmp_url}")
                try await stream.publish("{strean_key}")
                print("스트리밍 시작")
            } catch {
                print("스트리밍 오류: \(error.localizedDescription)")
            }
        }
    }
    
    /// 녹화 시작 시 매번 실행되는 메서드
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        if CMSampleBufferIsValid(sampleBuffer) {
            Task {
                await mixer.append(sampleBuffer)
            }
        }
    }
}
