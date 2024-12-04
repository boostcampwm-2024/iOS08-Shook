import UIKit

import EasyLayout

final class EasyLayoutDemoViewController: UIViewController {
    private let firstView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.frame.origin = CGPoint(x: 0, y: 0)
        return view
    }()

    private let secondView: UIView = {
        let view = UIView()
        view.frame.origin = CGPoint(x: 0, y: 0)
        return view
    }()

    private let thirdView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.frame.origin = CGPoint(x: 0, y: 0)
        return view
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttribute()
        setupSubViewsConstraints()
    }

    private func setupAttribute() {}

    private func setupSubViewsConstraints() {
        view.addSubview(firstView)
        view.addSubview(secondView)
        view.addSubview(thirdView)

        firstView.ezl.makeConstraint {
            $0.top(to: view.safeAreaLayoutGuide)
                .horizontal(to: view)
                .height(200)
        }

        secondView.ezl.makeConstraint {
            $0.top(to: firstView.ezl.bottom)
                .horizontal(to: view, padding: 40)
                .height(200)
        }

        thirdView.ezl.makeConstraint {
            $0.diagonal(to: view.safeAreaLayoutGuide, padding: 50)
        }
    }
}
