import Combine
import UIKit

import LiveStationDomainInterface

struct MockFetchChannelListUsecaseImpl: FetchChannelListUsecase {
    func execute() -> AnyPublisher<[ChannelEntity], any Error> {
        let fetcher = MockChannelListFetcher()

        return Future<[ChannelEntity], Error> { promise in
            Task {
                let channels = await fetcher.fetch()
                promise(.success(channels))
            }
        }
        .eraseToAnyPublisher()
    }
}

final class MockChannelListFetcher {
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

    func fetch() async -> [ChannelEntity] {
        let random = Int.random(in: 3...7)
        var channels: [ChannelEntity] = []

        for _ in 0..<random {
            let nameLength = Int.random(in: 4...50)
            let name = String((0..<nameLength).map { _ in
                "가나다라마바사아자차카타파하".randomElement()!
            })

            let randomBool = Bool.random()
            let image: Image = randomBool ? .ratio16x9 : .ratio4x3
            let fetchedImage = await image.fetch()

            channels.append(ChannelEntity(id: UUID().uuidString, name: name, image: fetchedImage))
        }

        return channels
    }
}