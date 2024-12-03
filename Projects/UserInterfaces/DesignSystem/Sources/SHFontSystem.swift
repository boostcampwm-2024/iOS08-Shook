import UIKit

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
        return style.font
    }
}

public extension UIFont.SHFontSystem {
    enum SHFontWeight {
        case bold, semiBold, regular, medium
    }
    
    var font: UIFont {
        return UIFont(font: weight.font, size: size) ?? .init()
    }
    
    var weight: SHFontWeight {
        switch self {
        case let .title(weight),
            let .body1(weight),
            let .body2(weight),
            let .body3(weight),
            let .caption1(weight),
            let .caption2(weight):
            return weight
        }
    }
    
    var size: CGFloat {
        switch self {
        case .title: return 22
        case .body1: return 17
        case .body2: return 16
        case .body3: return 14
        case .caption1: return 12
        case .caption2: return 10
        }
    }
    
}

private extension UIFont.SHFontSystem.SHFontWeight {
    var font: DesignSystemFontConvertible {
        switch self {
        case .bold: return DesignSystemFontFamily.PretendardVariable.bold
        case .semiBold: return DesignSystemFontFamily.PretendardVariable.semiBold
        case .regular: return DesignSystemFontFamily.PretendardVariable.regular
        case .medium: return DesignSystemFontFamily.PretendardVariable.medium
        }
    }
}
