import UIKit

import AuthFeature

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewModel = SignUpViewModel()
        let viewController = SignUpViewController(viewModel: viewModel)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }
}