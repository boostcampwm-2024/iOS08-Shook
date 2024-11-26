import UIKit

import BaseFeature
import BaseFeatureInterface
import DesignSystem

public final class SplashViewController: BaseViewController<SplashViewModel> {

    private let gradientsColor: [CGColor] = [#colorLiteral(red: 0.08536987752, green: 0.09035866708, blue: 0.1243042126, alpha: 1), #colorLiteral(red: 0.09964027256, green: 0.2065343261, blue: 0.2179464698, alpha: 1)]
    private let gradientLayer = CAGradientLayer()
    
    @Published private var viewDidLoadPublisher: Void?
    
    lazy var input = SplashViewModel.Input(viewDidLoad: $viewDidLoadPublisher.eraseToAnyPublisher())
    lazy var output = viewModel.transform(input: input)
    

    
    public override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadPublisher = ()
    }
    
    public override func setupViews() {
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    public override func setupStyles() {
        gradientLayer.colors = gradientsColor
        
        gradientLayer.type = .axial
        gradientLayer.startPoint = CGPoint(x: 0.8, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.2, y: 1)
    }

}
