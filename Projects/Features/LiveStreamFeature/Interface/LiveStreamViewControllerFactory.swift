import UIKit

import BaseFeatureInterface

public protocol LiveStreamViewControllerFactory {
    func make() -> UIViewController
}
