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
    func fetch() -> [Item] {
        return []
    }
}

public protocol Fetcher {
    func fetch() -> [Item]
}

public class BroadcastCollectionViewModel: ViewModel {
    private let outputData = CurrentValueSubject<Output, Never>(.data(items: []))
    private var cancellables = Set<AnyCancellable>()
    private var fetcher: Fetcher
    
    public init(fetcher: Fetcher) {
        self.fetcher = fetcher
    }
    
    public enum Input {
        case fetch
    }
    
    public enum Output {
        case data(items: [Item])
    }
    
    public func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .fetch:
                self?.fetchData()
            }
        }.store(in: &cancellables)
        
        return outputData.eraseToAnyPublisher()
    }
    
    private func fetchData() {
        let fetchedItems = fetcher.fetch()
        outputData.send(.data(items: fetchedItems))
    }
}
