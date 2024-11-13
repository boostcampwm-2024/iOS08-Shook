import UIKit

extension UIView {
    public var ezl: EasyLayout {
        EasyLayout(EasyConstraint(self))
    }
}
