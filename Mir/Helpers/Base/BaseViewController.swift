//
//  BaseViewController.swift
//  Mir
//
//  Created by Dmitry Rogov on 06.12.2021.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    var safeAreaBottomInset: CGFloat { view.safeAreaInsets.bottom }
    
    var bag = DisposeBag()
        
}
