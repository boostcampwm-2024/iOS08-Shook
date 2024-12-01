import UIKit

public protocol BroadcastViewControllerFactory {
    func make() -> UIViewController
}
