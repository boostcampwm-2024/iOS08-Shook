//
//  BroadcastViewController.swift
//  Shook
//
//  Created by hyunjun on 11/6/24.
//

import ReplayKit
import UIKit

class BroadcastViewController: UIViewController {
    var mixer: MediaMixer!
    var connection: RTMPConnection!
    var stream: RTMPStream!
    
    var broadcastPicker: RPSystemBroadcastPickerView!
    
    var isStreaming: Bool = false
    var isTestButtonTapped: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AVCaptureDevice.requestAccess(for: .video) { _ in }
        AVCaptureDevice.requestAccess(for: .audio) { _ in }
                
        mixer = MediaMixer(multiCamSessionEnabled: false, multiTrackAudioMixingEnabled: true)
        connection = RTMPConnection()
        stream = RTMPStream(connection: connection)
        
        broadcastPicker = RPSystemBroadcastPickerView(frame: .init(x: UIScreen.main.bounds.width / 4, y: UIScreen.main.bounds.height / 3, width: 200, height: 60))
        broadcastPicker.preferredExtension = EXTENSION_BUNDLE_IDENTIFIER
        view.addSubview(broadcastPicker)
        
        Task {
            do {
                await mixer.setVideoRenderingMode(.passthrough)
                try await mixer.attachAudio(AVCaptureDevice.default(for: .audio))
                await mixer.addOutput(stream)
            } catch {
                print("장치 연결 오류: \(error)")
            }
        }
        
        let playButton = UIButton()
        playButton.setTitle("Start Streaming", for: .normal)
        playButton.backgroundColor = .systemBlue
        playButton.layer.cornerRadius = 12
        playButton.setTitleColor(.white, for: .normal)
        playButton.frame = .init(x: UIScreen.main.bounds.width / 4, y: UIScreen.main.bounds.height / 4, width: 200, height: 60)
        playButton.addTarget(self, action: #selector(toggle), for: .touchUpInside)
        view.addSubview(playButton)
        
        let testButton = UIButton()
        testButton.setTitle("Test", for: .normal)
        testButton.backgroundColor = .systemBlue
        testButton.layer.cornerRadius = 12
        testButton.setTitleColor(.white, for: .normal)
        testButton.frame = .init(x: UIScreen.main.bounds.width / 4, y: UIScreen.main.bounds.height / 2, width: 200, height: 60)
        testButton.addTarget(self, action: #selector(toggleColor), for: .touchUpInside)
        view.addSubview(testButton)
    }
    
    @objc func toggle(sender: UIButton) {
        if isStreaming {
            stopStreaming()
            stopScreenRecording()
            sender.setTitle("Start Streaming", for: .normal)
            sender.backgroundColor = .systemBlue
        } else {
            startStreaming(rtmpURL: RTMP_URL, streamKey: STREAM_KEY)
            startScreenRecording()
            sender.setTitle("Stop Streaming", for: .normal)
            sender.backgroundColor = .systemRed
        }
        isStreaming.toggle()
    }
    
    @objc func toggleColor(sender: UIButton) {
        if isTestButtonTapped {
            sender.backgroundColor = .systemGray
        } else {
            sender.backgroundColor = .systemYellow
        }
        
        isTestButtonTapped.toggle()
    }
    
    func startStreaming(rtmpURL: String, streamKey: String) {
        Task {
            do {
                try await connection.connect(rtmpURL)
                try await stream.publish(streamKey)
                print("스트리밍 시작")
            } catch {
                print("스트리밍 오류: \(error.localizedDescription)")
            }
        }
    }
    
    func stopStreaming() {
        Task {
            do {
                try await stream.close()
                try await connection.close()
                print("스트리밍 종료")
            } catch {
                print("스트리밍 종료 오류: \(error.localizedDescription)")
            }
        }
    }
    
    func startScreenRecording() {
        let recorder = RPScreenRecorder.shared()
        recorder.isMicrophoneEnabled = true
        
        recorder.startCapture { [self] (sampleBuffer, bufferType, error) in
            if let error = error {
                print("화면 녹화 오류: \(error.localizedDescription)")
                return
            }
                        
            if bufferType == .video {
                if CMSampleBufferIsValid(sampleBuffer) {
                    Task { await mixer.append(sampleBuffer) }
                }
            }
        } completionHandler: { error in
            if let error = error {
                print("화면 녹화 시작 오류: \(error.localizedDescription)")
            } else {
                print("화면 녹화 시작")
            }
        }
    }
    
    func stopScreenRecording() {
        RPScreenRecorder.shared().stopCapture { error in
            if let error = error {
                print("화면 녹화 중지 오류: \(error)")
            } else {
                print("화면 녹화 중지됨")
            }
        }
    }
}
