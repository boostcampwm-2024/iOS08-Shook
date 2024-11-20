import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = ViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }
}

import BaseFeature
import EasyLayoutModule
import LiveStreamFeature

final class ViewController: UIViewController {
    private let chatView = ChatingListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttribute()
        setupSubViewsConstraints()
    }
    
    private func setupAttribute() {
        view.backgroundColor = .black
    }
    
    private func setupSubViewsConstraints() {
        view.addSubview(chatView)
        
        chatView.ezl.makeConstraint {
            $0.diagonal(to: view.safeAreaLayoutGuide)
        }
    }
}
