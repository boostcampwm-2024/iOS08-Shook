import UIKit

import MainFeature

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = SettingUIViewController(viewModel: SettingViewModel())
        //let viewController = BroadcastUIViewController(viewModel: BroadcastCollectionViewModel())
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }
}
