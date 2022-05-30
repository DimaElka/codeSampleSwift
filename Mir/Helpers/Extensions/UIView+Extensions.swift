//
//  UIView+Extensions.swift
//  Mir
//
//  Created by Dmitry Rogov on 06.12.2021.
//

import UIKit

//MARK: - Round corners
extension UIView {
    func roundCorners(with radius: CGFloat) {
        layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            layer.masksToBounds = true
        }
    }
}

//MARK: - Shadow
extension UIView {
    func setupShadow(radius: CGFloat = 1,
                     offset: CGSize = CGSize(width: 0, height: 0),
                     opacity: Float = 1.0) {
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
    }
    
    func updateShadowColor(_ color: UIColor?) {
        layer.shadowColor = color?.cgColor
    }
}
