import UIKit

import EasyLayoutModule

final class EasyLayoutDemoViewController: UIViewController {
    private let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.frame.origin = CGPoint(x: 0, y: 0)
        return view
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttribute()
        setupSubViewsConstraints()
    }
    
    private func setupAttribute() {}
    
    private func setupSubViewsConstraints() {
        view.addSubview(emptyView)
        
        emptyView.ezl.makeConstraint {
            $0.height(100).width(100)
        }
    }
}
