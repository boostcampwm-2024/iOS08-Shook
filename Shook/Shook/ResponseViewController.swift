//
//  ResponseViewController.swift
//  Shook
//
//  Created by inye on 11/4/24.
//

import UIKit
import AVKit

final class ResponseViewController: UIViewController {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let button: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "재생"
        config.baseForegroundColor = .white
        
        let button = UIButton(configuration: config)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(button)
        setUpLayout()
        button.addAction(UIAction(handler: { [weak self] _ in
            
            guard let self else { return }
            
            Task {
                await self.getGeneral()
            }
            
        }), for: .primaryActionTriggered)
    }
    
    private func setUpLayout() {
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: 100),
            button.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    
    
    func getThumbnail() async {
        let decoder = JSONDecoder()
        let network = NetworkProvider()
        do {
            async let data = try await network.request(of: ServiceURLAPI.getThumbnail)
            let result = try await decoder.decode(ServiceURLDTO.self, from: data)
            await MainActor.run {
                guard let imageString = result.content.last?.resizedUrl?.last?.url,
                      let imageURL = URL(string: imageString),
                      let data = try? Data(contentsOf: imageURL)
                else { return }
                imageView.image = UIImage(data: data)
            }
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func getGeneral() async {
        let decoder = JSONDecoder()
        let network = NetworkProvider()
        do {
            async let data = try await network.request(of: ServiceURLAPI.getGeneral)
            let result = try await decoder.decode(ServiceURLDTO.self, from: data)
            await MainActor.run {
                guard let videoString = result.content.last?.url,
                      let videoURL = URL(string: videoString)
                else { return }
                playVideo(fileURL: videoURL)
            }
        } catch {
            showAlert()
        }
    }
    
    private func playVideo(fileURL: URL) {
        let playerController = AVPlayerViewController()
        let player = AVPlayer(url: fileURL)
        
        playerController.player = player
        
        self.present(playerController, animated: true) {
            player.play()
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "스트리밍 오류 발생", message: "현재 재생 중이 아닙니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
