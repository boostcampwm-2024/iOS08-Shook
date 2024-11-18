import UIKit

import BaseFeatureInterface

open class BaseViewController: UIViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayouts()
        setupActions()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupStyles()
    }
}

extension BaseViewController: ViewLifeCycle {
    open func setupViews() { }
    
    open func setupStyles() { }
    
    open func updateStyles() { }
    
    open func setupLayouts() { }
    
    open func updateLayouts() { }
    
    open func setupActions() { }
}
