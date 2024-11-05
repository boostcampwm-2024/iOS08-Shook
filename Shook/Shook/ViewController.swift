//
//  ViewController.swift
//  Shook
//
//  Created by hyunjun on 11/4/24.
//

import AVFoundation
import UIKit

class ViewController: UIViewController {
    /// 방송에 필요한 타입들
    var mixer: MediaMixer!
    var connection: RTMPConnection!
    var stream: RTMPStream!
    
    var isStreaming: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 권한 요청
        AVCaptureDevice.requestAccess(for: .video) { _ in }
        AVCaptureDevice.requestAccess(for: .audio) { _ in }
        
        mixer = MediaMixer()
        connection = RTMPConnection()
        stream = RTMPStream(connection: connection)
        
        Task {
            do {
                /// mixer 에 Device 추가
                try await mixer.attachVideo(AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back))
                try await mixer.attachAudio(AVCaptureDevice.default(for: .audio))
            } catch {
                print(error.localizedDescription)
            }
            
            await mixer.addOutput(stream)
        }

        let playButton = UIButton()
        playButton.setTitle("Start Streaming", for: .normal)
        playButton.backgroundColor = .systemBlue
        playButton.layer.cornerRadius = 12
        playButton.setTitleColor(.white, for: .normal)
        playButton.frame = .init(x: UIScreen.main.bounds.width / 4, y: UIScreen.main.bounds.height / 2, width: 200, height: 60)
        playButton.isUserInteractionEnabled = true
        playButton.addTarget(self, action: #selector(toggle), for: .touchUpInside)
        view.addSubview(playButton)
    }
    
    /// 방송 시작, 종료 toggle
    @objc func toggle(sender: UIButton) {
        if isStreaming {
            stopStreaming()
            sender.setTitle("Start Streaming", for: .normal)
            sender.backgroundColor = .systemBlue
        } else {
            startStreaming(rtmpURL: "RTMP_URL", streamKey: "STREAM_KEY")
            sender.setTitle("Stop Streaming", for: .normal)
            sender.backgroundColor = .systemRed
        }

        isStreaming.toggle()
    }
    
    func startStreaming(rtmpURL: String, streamKey: String) {
        Task {
            do {
                try await connection.connect(rtmpURL)
                try await stream.publish(streamKey)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func stopStreaming() {
        Task {
            do {
                try await stream.close()
                try await connection.close()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
