//
//  BaseCoordinator.swift
//  Mir
//
//  Created by Dmitry Rogov on 06.12.2021.
//

import UIKit
import RxSwift

class BaseCoordinator {
    
    weak var navController: UINavigationController?
    private weak var presentedCoordinator: BaseCoordinator?
    
    let bag = DisposeBag()

    init(navController: UINavigationController) {
        self.navController = navController
    }
}

//MARK: - Input
extension BaseCoordinator {
    func present(controller: UIViewController, for coordinator: BaseCoordinator) {
        navController?.present(controller, animated: true, completion: nil)
        presentedCoordinator = coordinator
    }
    
    func topPresentedCoordinator() -> BaseCoordinator {
        if let presentedCoordinator = presentedCoordinator {
            return presentedCoordinator.topPresentedCoordinator()
        } else {
            return self
        }
    }
}
