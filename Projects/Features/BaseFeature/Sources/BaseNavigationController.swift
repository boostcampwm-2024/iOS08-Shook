import UIKit

open class BaseNavigationController: UINavigationController {
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        topViewController?.supportedInterfaceOrientations ?? .portrait
    }
}
