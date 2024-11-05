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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayout()
        Task {
            //await getThumbnail()
            await getGeneral()
        }
    }
    
    private func setUpLayout() {
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 500)
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
            print("error: \(error.localizedDescription)")
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
}
