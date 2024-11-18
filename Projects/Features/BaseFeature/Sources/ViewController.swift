import UIKit

import BaseFeatureInterface

open class ViewController: UIViewController {
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

extension ViewController: ViewLifeCycle {
    public func setupViews() { }
    
    public func setupStyles() { }
    
    public func updateStyles() { }
    
    public func setupLayouts() { }
    
    public func updateLayouts() { }
    
    public func setupActions() { }
}
