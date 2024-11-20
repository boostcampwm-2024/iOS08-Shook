import UIKit

import BaseFeature
import DesignSystem
import EasyLayoutModule


public final class LiveStreamViewController: BaseViewController<LiveStreamViewModel> {

    private let playerView: ShookPlayerView = ShookPlayerView(with:  URL(string: "https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8")!)
    
    public override func setupViews() {
        view.addSubview(playerView)
    }
    
    public override func setupLayouts() {
        playerView.ezl.makeConstraint {
            $0.top(to: view.safeAreaLayoutGuide)
                .horizontal(to: view.safeAreaLayoutGuide)
                .height(200)
        }
    }
    
    public override func setupStyles() {
        view.backgroundColor = .black
    }
}
