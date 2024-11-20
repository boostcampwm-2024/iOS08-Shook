import Combine
import UIKit

import BaseFeatureInterface

public struct Item: Hashable {
    let id = UUID().uuidString
    var image: UIImage?
    var title: String
    var subtitle1: String
    var subtitle2: String
    
    public init(image: UIImage? = nil, title: String, subtitle1: String, subtitle2: String) {
        self.image = image
        self.title = title
        self.subtitle1 = subtitle1
        self.subtitle2 = subtitle2
    }
}

class BroadcastFetcher: Fetcher {
    func fetch() async -> [Item] {
        return []
    }
}

public protocol Fetcher {
    func fetch() async -> [Item]
}

public class BroadcastCollectionViewModel: ViewModel {
    public struct Input {
        let fetch: PassthroughSubject<Void, Never> = .init()
    }
    
    public struct Output {
        let items: CurrentValueSubject<[Item], Never> = .init([])
    }
    
    private let output = Output()
    private var cancellables = Set<AnyCancellable>()
    private var fetcher: Fetcher
    
    public init(fetcher: Fetcher) {
        self.fetcher = fetcher
    }
    
    public func transform(input: Input) -> Output {
        input.fetch
            .sink { [weak self] in
                self?.fetchData()
            }
            .store(in: &cancellables)
        
        return output
    }
    
    private func fetchData() {
        Task {
            let fetchedItems = await fetcher.fetch()
            output.items.send(fetchedItems)
        }
    }
}
