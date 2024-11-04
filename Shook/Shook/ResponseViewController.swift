//
//  ResponseViewController.swift
//  Shook
//
//  Created by inye on 11/4/24.
//

import UIKit

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
            await getThumbnail()
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
            let result = try await decoder.decode(ThumbnailDTO.self, from: data)
            await MainActor.run {
                guard let imageString = result.content.last?.resizedUrl.last?.url,
                      let imageURL = URL(string: imageString),
                      let data = try? Data(contentsOf: imageURL)
                else { return }
                imageView.image = UIImage(data: data)
            }
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
}
