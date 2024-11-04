//
//  ViewController.swift
//  Shook
//
//  Created by hyunjun on 11/4/24.
//

import AVFoundation
import UIKit

class ViewController: UIViewController {
    var mixer: MediaMixer!
    var connection: RTMPConnection!
    var stream: RTMPStream!
    var hkView: MTHKView!
    var isStreaming: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AVCaptureDevice.requestAccess(for: .video) { _ in }
        AVCaptureDevice.requestAccess(for: .audio) { _ in }
        
        mixer = MediaMixer()
        connection = RTMPConnection()
        stream = RTMPStream(connection: connection)
        
        Task {
            do {
                try await mixer.attachVideo(AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back))
                try await mixer.attachAudio(AVCaptureDevice.default(for: .audio))
            } catch {
                print("장치 연결 오류: \(error)")
            }
            
            await mixer.addOutput(stream)
        }
        
        hkView = MTHKView(frame: view.bounds)
        hkView.videoGravity = .resizeAspectFill
        view.addSubview(hkView)
        
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
    
    @objc func toggle(sender: UIButton) {
        print("tapped")
        
        if isStreaming {
            stopStreaming()
            sender.setTitle("Start Streaming", for: .normal)
            sender.backgroundColor = .systemBlue
        } else {
            startStreaming(rtmpURL: "rtmp://rtmp-ls2-k1.video.media.ntruss.com:8080/relay", streamKey: "yddxaffb6tpcexw25ery143v71xoy2dj")
            sender.setTitle("Stop Streaming", for: .normal)
            sender.backgroundColor = .systemRed
        }
        isStreaming.toggle()
    }
    
    func startStreaming(rtmpURL: String, streamKey: String) {
        Task {
            do {
                let response1 = try await connection.connect(rtmpURL)
                let response2 = try await stream.publish(streamKey)
                print(response1.status ?? "??")
                print(response2.status ?? "??")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func stopStreaming() {
        Task {
            do {
                let response = try await stream.close()
                try await connection.close()
                print(response.status ?? "??")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

