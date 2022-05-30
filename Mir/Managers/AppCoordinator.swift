//
//  AppCoordinator.swift
//  Mir
//
//  Created by Dmitry Rogov on 06.12.2021.
//

import UIKit
import RxSwift
import RxCocoa

class AppCoordinator {
    
    static let shared = AppCoordinator()

    private let bag = DisposeBag()
    private weak var actionsCoordinator: ActionsCoordinator?

    private init() { }

    func start() {
        let navController = UINavigationController()
        let actionsCoordinator = ActionsCoordinator(navController: navController)
        let viewController = actionsCoordinator.startController()
        navController.setViewControllers([viewController], animated: false)
        self.actionsCoordinator = actionsCoordinator

        let appDelegate = AppDelegate.shared
        let window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window = window
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
}

//MARK: - Input
extension AppCoordinator {
    func showDeeplink(_ deeplink: Deeplink) {
        DispatchQueue.main.async {
            switch deeplink {
            case .action(let actionId):
                self.showActionDetail(with: actionId)
            case .feedback:
                self.showFeedback()
            }
        }
    }
}

//MARK: - Private
extension AppCoordinator {
    func topPresentedCoordinator() -> BaseCoordinator? {
        actionsCoordinator?.topPresentedCoordinator()
    }
    
    private func showActionDetail(with id: String) {
        guard let topPresentedCoordinator = topPresentedCoordinator() else {
            assertionFailure("Should not be nil")
            return
        }
        
        let presentingNavController = UINavigationController()
        let coord = ActionCoordinator(actionId: id, navController: presentingNavController)
        let controller = coord.startController()
        coord.output.close
            .bind(onNext: { [weak presentingNavController] _ in
                presentingNavController?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: coord.bag)
        
        presentingNavController.setViewControllers([controller], animated: false)
        topPresentedCoordinator.present(controller: presentingNavController, for: coord)
    }
    
    private func showFeedback() {
        guard let topPresentedCoordinator = topPresentedCoordinator() else {
            assertionFailure("Should not be nil")
            return
        }

        let presentingNavController = UINavigationController()
        let coord = FeedbackCoordinator(navController: presentingNavController)
        let controller = coord.startController()
        coord.output.close
            .bind(onNext: { [weak presentingNavController] _ in
                presentingNavController?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: coord.bag)
        
        presentingNavController.setViewControllers([controller], animated: false)
        topPresentedCoordinator.present(controller: presentingNavController, for: coord)
    }
}
