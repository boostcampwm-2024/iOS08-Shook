import UIKit

import ChatSoketModule

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = SoketTestViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }
}
