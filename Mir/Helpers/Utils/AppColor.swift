//
//  AppColor.swift
//  Mir
//
//  Created by Dmitry Rogov on 06.12.2021.
//

import UIKit
enum AppColor: String {
    case shadow
    case border
    
    case background
    case backgroundSecondary
    
    case text
    case textSecondary
    
    case main
    case mainLight
    
    case buttonActiveBackground
    case buttonActiveTitle
    case buttonDisabledBackground
    case buttonDisabledTitle
    
    case textFieldActiveTint
    case textFieldInactiveTint
    case textFieldError
}

extension UIColor {
    static func color(named appColor: AppColor) -> UIColor {
        let bundle = Bundle.main
        guard let color = UIColor(named: appColor.rawValue, in: bundle, compatibleWith: nil) else {
            assertionFailure("Color not found for name \(appColor.rawValue)")
            return UIColor.white
        }
        
        return color
    }
}
