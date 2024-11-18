import UIKit

import BaseFeatureInterface

open class View: UIView {
    public init() {
        super.init(frame: .zero)
        setupViews()
        setupLayouts()
        setupActions()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayouts()
        setupActions()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupLayouts()
        setupActions()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        setupStyles()
    }
}

extension View: ViewLifeCycle {
    public func setupViews() { }
    
    public func setupLayouts() { }
    
    public func updateLayouts() { }
    
    public func setupStyles() { }
    
    public func updateStyles() { }
    
    public func setupActions() { }
}
