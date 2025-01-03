import UIKit

import BaseFeatureInterface

open class BaseViewController<VM: ViewModel>: UIViewController, ViewLifeCycle {
    public var viewModel: VM

    public init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupStyles()
        setupLayouts()
        setupActions()
        setupBind()
    }

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }

    // MARK: - View Life Cycle

    open func setupBind() {}

    open func setupViews() {}

    open func setupStyles() {}

    open func updateStyles() {}

    open func setupLayouts() {}

    open func updateLayouts() {}

    open func setupActions() {}
}
