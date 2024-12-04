import UIKit

// MARK: - Anchorable

public protocol Anchorable {
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

public extension Anchorable {
    var ezl: EasyLayout {
        EasyLayout(EasyConstraint(self))
    }
}

// MARK: - UIView + Anchorable

extension UIView: Anchorable {}

// MARK: - UILayoutGuide + Anchorable

extension UILayoutGuide: Anchorable {}
