import UIKit

import BaseFeatureInterface

open class BaseTableViewCell: UITableViewCell, ViewLifeCycle {
    public static var identifier: String {
        String(describing: Self.self)
    }
    
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
    
    // MARK: - View Life Cycle
    open func setupViews() { }

    open func setupLayouts() { }
    
    open func updateLayouts() { }
    
    open func setupStyles() { }
    
    open func updateStyles() { }
    
    open func setupActions() { }
}
