import UIKit

public protocol LiveStreamViewControllerFactory {
    func make() -> UIViewController
}
