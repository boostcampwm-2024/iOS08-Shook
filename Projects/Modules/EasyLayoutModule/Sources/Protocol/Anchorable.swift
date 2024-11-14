import UIKit

public protocol Anchorable {
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
}

extension Anchorable {
    public var ezl: EasyLayout {
        EasyLayout(EasyConstraint(self))
    }
}

extension UIView: Anchorable {}

extension UILayoutGuide: Anchorable {}
