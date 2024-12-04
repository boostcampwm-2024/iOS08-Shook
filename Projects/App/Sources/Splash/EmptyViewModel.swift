import BaseFeatureInterface

public class EmptyViewModel: ViewModel {
    public struct Input {}
    public struct Output {}

    public func transform(input _: Input) -> Output {
        Output()
    }
}
