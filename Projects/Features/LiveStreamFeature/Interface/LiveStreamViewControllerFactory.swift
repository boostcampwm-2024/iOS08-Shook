import UIKit

import BaseFeatureInterface

public protocol LiveStreamViewControllerFactory {
    func make(channelID: String, title: String, owner: String, description: String) -> UIViewController
}
