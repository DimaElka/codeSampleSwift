//
//  UICollectionView+Reusable.swift
//  Mir
//
//  Created by Dmitry Rogov on 06.12.2021.
//

import UIKit

public extension UICollectionView {
    func cell<T: UICollectionViewCell>(forClass cellClass: T.Type = T.self, indexPath: IndexPath) -> T {
        let className = String(describing: cellClass)
        guard let cell = dequeueReusableCell(withReuseIdentifier: className, for: indexPath) as? T else { return T() }
        return cell
    }
    
    func register<T: UICollectionViewCell>(cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: String(describing: cellType))
    }
}
