import Combine
import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule

public final class LiveStreamViewController: BaseViewController<LiveStreamViewModel> {
    
    var orientation: UIInterfaceOrientationMask = .portrait
    var tempConstraints: NSLayoutConstraint?
    var tempConstraints2: NSLayoutConstraint?
    var subscription: Set<AnyCancellable> = .init()
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return orientation
    }
    
    private let playerView: ShookPlayerView = ShookPlayerView(with: URL(string: "https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8")!)
    
    public override func setupViews() {
        view.addSubview(playerView)
    }
    
    public override func setupLayouts() {
        playerView.ezl.makeConstraint {
            $0.top(to: view.safeAreaLayoutGuide)
                .horizontal(to: view.safeAreaLayoutGuide)
        }
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let width = windowScene.screen.bounds.width
    
        tempConstraints = playerView.heightAnchor.constraint(equalToConstant: 200)
        tempConstraints?.isActive = true
        tempConstraints2 = playerView.heightAnchor.constraint(equalToConstant: width)
    }
    
    public override func setupActions() {
        playerView.playerControlView
            .expandButtonDidTap
            .dropFirst()
            .sink { [weak self] _ in
                guard let self else { return }
                self.changeOrientation()
            }
            .store(in: &subscription)
    }
    
    public override func setupStyles() {
        view.backgroundColor = .black
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if orientation == .landscapeLeft {
            tempConstraints?.isActive = false
            tempConstraints2?.isActive = true
        } else {
            tempConstraints2?.isActive = false
            tempConstraints?.isActive = true
        }
        
    }
}

extension LiveStreamViewController {
    func changeOrientation() {
        let appDelegate = UIApplication.shared.delegate
        
        orientation = orientation == .portrait ? .landscapeLeft : .portrait

        if #available(iOS 16.0, *) {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                self.setNeedsUpdateOfSupportedInterfaceOrientations()
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientation)) { error in
                    print("ERR: \(error)")
                }
        } else {
            UIDevice.current.setValue(orientation, forKey: "orientation")
        }
        
    }
}
