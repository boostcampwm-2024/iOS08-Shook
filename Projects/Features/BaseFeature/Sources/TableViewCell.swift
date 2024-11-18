import UIKit

import BaseFeatureInterface

open class TableViewCell: UITableViewCell {
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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

extension TableViewCell: ViewLifeCycle {
    public func setupViews() { }

    public func setupLayouts() { }
    
    public func updateLayouts() { }
    
    public func setupStyles() { }
    
    public func updateStyles() { }
    
    public func setupActions() { }
}
