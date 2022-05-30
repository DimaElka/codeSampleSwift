//
//  BaseCollectionViewCell.swift
//  Mir
//
//  Created by Dmitry Rogov on 06.12.2021.
//

import UIKit
import RxSwift

class BaseCollectionViewCell: UICollectionViewCell {
    var bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initialSetup()
    }
    
    func initialSetup() {}
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bag = DisposeBag()
    }
}

