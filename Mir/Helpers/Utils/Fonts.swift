//
//  Fonts.swift
//  Mir
//
//  Created by Dmitry Rogov on 06.12.2021.
//

import UIKit

public enum FontStyle: CaseIterable {
    case medium
    case regular

    var name: String {
        switch self {
        case .medium:
            return "GothamSSm-Medium"
        case .regular:
            return "GothamSSm-Book"
        }
    }
}

extension UIFont {
    static func appFont(style: FontStyle, size: CGFloat) -> UIFont {
        return UIFont(name: style.name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
