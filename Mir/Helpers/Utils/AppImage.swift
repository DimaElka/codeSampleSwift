//
//  AppImage.swift
//  Mir
//
//  Created by Dmitry Rogov on 06.12.2021.
//

import UIKit

enum AppImage: String {
    case closeIcon
    case feedbackIcon
    case rulesIcon
    case siteIcon
    
    case actionImagePlaceholder
}

extension UIImage {
    static func image(named image: AppImage) -> UIImage {
        let bundle = Bundle.main
        guard let image = UIImage(named: image.rawValue, in: bundle, compatibleWith: nil) else {
            assertionFailure("Image not found for name \(image.rawValue)")
            return UIImage()
        }
        
        return image
    }
}
