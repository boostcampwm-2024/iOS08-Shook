import Combine
import Foundation

import BaseFeatureInterface

public final class ChatingViewModel: ViewModel {
    public struct Input { }
    
    public struct Output {
        let chatList = CurrentValueSubject<[ChatInfo], Never>(
            (0..<10).map { _ in
                ChatInfo(name: "", message: "")
            }
        )
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let output = Output()
    
    public init() { }
    
    public func transform(input: Input) -> Output {
        return output
    }
}
