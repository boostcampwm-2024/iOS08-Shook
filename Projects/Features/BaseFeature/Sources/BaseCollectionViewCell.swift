import UIKit

import BaseFeatureInterface

open class BaseCollectionViewCell: UICollectionViewCell, ViewLifeCycle {
    public static var identifier: String {
        String(describing: Self.self)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupStyles()
        setupLayouts()
        setupActions()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupStyles()
        setupLayouts()
        setupActions()
    }
    
    open func setupViews() { }
    
    open func setupStyles() { }
    
    open func updateStyles() { }
    
    open func setupLayouts() { }
    
    open func updateLayouts() { }
    
    open func setupActions() { }
}
