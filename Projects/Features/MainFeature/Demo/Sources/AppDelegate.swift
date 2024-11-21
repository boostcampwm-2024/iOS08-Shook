import UIKit

import MainFeature

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let fetcher = MockFetcher()
        let viewModel = BroadcastCollectionViewModel(fetcher: fetcher)
        let viewController = BroadcastCollectionViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

final class MockFetcher: Fetcher {
    enum Image {
        case ratio16x9
        case ratio4x3

        func fetch() async -> UIImage? {
            let size: (width: Int, height: Int)
            switch self {
            case .ratio16x9: size = (1920, 1080)
            case .ratio4x3: size = (1440, 1080)
            }
            return await fetchImage(width: size.width, height: size.height)
        }
        
        private func fetchImage(width: Int, height: Int) async -> UIImage? {
            guard let url = URL(string: "https://picsum.photos/\(width)/\(height)") else { return nil }
            
            let data = (try? await URLSession.shared.data(from: url).0) ?? Data()
            return UIImage(data: data)
        }
    }
    
    func fetch() async -> [Item] {
        let itemCount = Int.random(in: 3...7)
        var items: [Item] = []

        for _ in 0..<itemCount {
            let titleLength = Int.random(in: 4...50)
            let title = String((0..<titleLength).map { _ in
                "가나다라마바사아자차카타파하".randomElement()!
            })

            let randomBool = Bool.random()
            let image: Image = randomBool ? .ratio16x9 : .ratio4x3
            let fetchedImage = await image.fetch()

            let subtitle1 = randomBool ? "16 * 9 비율 이미지" : "4 * 3 비율 이미지"
            let subtitle2 = Bool.random() ? "1920 * 1080" : "1440 * 1080"

            items.append(Item(image: fetchedImage, title: title, subtitle1: subtitle1, subtitle2: subtitle2))
        }

        return items
    }
}
