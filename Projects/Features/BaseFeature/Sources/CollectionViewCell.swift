import UIKit

import BaseFeatureInterface

open class CollectionViewCell: UICollectionViewCell {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayouts()
        setupActions()
    }
    
    required public init?(coder: NSCoder) {
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

extension CollectionViewCell: ViewLifeCycle {
    public func setupViews() { }
    
    public func setupStyles() { }
    
    public func updateStyles() { }
    
    public func setupLayouts() { }
    
    public func updateLayouts() { }
    
    public func setupActions() { }
}
