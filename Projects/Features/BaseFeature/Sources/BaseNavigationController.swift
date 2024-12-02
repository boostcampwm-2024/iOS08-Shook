import UIKit

open class BaseNavigationController: UINavigationController {
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        topViewController?.supportedInterfaceOrientations ?? .portrait
    }
}
