import UIKit

import AuthFeature

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let mockCreateChannelUsecase = MockCreateChannelUsecaseImpl()
        let viewModel = SignUpViewModel(createChannelUsecase: mockCreateChannelUsecase)
        let viewController = SignUpViewController(viewModel: viewModel)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }
}
