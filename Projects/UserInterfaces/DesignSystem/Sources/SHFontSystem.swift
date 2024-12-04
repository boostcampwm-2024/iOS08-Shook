import UIKit

// MARK: - SHFontable

protocol SHFontable {
    var font: UIFont { get }
}

public extension UIFont {
    enum SHFontSystem: SHFontable {
        case title(weight: SHFontWeight = .bold)
        case body1(weight: SHFontWeight = .semiBold)
        case body2(weight: SHFontWeight = .regular)
        case body3(weight: SHFontWeight = .medium)
        case caption1(weight: SHFontWeight = .regular)
        case caption2(weight: SHFontWeight = .regular)
    }

    static func setFont(_ style: SHFontSystem) -> UIFont {
        style.font
    }
}

public extension UIFont.SHFontSystem {
    enum SHFontWeight {
        case bold
        case semiBold
        case regular
        case medium
    }

    var font: UIFont {
        UIFont(font: weight.font, size: size) ?? .init()
    }

    var weight: SHFontWeight {
        switch self {
        case let .body1(weight),
             let .body2(weight),
             let .body3(weight),
             let .caption1(weight),
             let .caption2(weight),
             let .title(weight):
            weight
        }
    }

    var size: CGFloat {
        switch self {
        case .title: 22
        case .body1: 17
        case .body2: 16
        case .body3: 14
        case .caption1: 12
        case .caption2: 10
        }
    }
}

private extension UIFont.SHFontSystem.SHFontWeight {
    var font: DesignSystemFontConvertible {
        switch self {
        case .bold: DesignSystemFontFamily.PretendardVariable.bold
        case .semiBold: DesignSystemFontFamily.PretendardVariable.semiBold
        case .regular: DesignSystemFontFamily.PretendardVariable.regular
        case .medium: DesignSystemFontFamily.PretendardVariable.medium
        }
    }
}
