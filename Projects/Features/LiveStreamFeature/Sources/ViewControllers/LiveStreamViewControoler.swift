import BaseFeature
import EasyLayoutModule
import UIKit

public final class LiveStreamViewControoler: BaseViewController<LiveStreamViewModel> {

    private let playerView: ShookPlayerView = ShookPlayerView()
    
    public override func setupViews() {
        view.addSubview(playerView)
    }
    
    public override func setupLayouts() {
        playerView.ezl.makeConstraint {
            $0.top(to: view)
              .horizontal(to: view)
              .height(200)
        }
    }
}
