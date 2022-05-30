//
//  ActionsCoordinator.swift
//  Mir
//
//  Created by Dmitry Rogov on 06.12.2021.
//

import UIKit
import RxSwift
import RxRelay

class ActionsCoordinator: BaseCoordinator {
    struct Output {
    }
    
    let output = Output()
}

//MARK: Input
extension ActionsCoordinator {
    func startController() -> UIViewController {
        let controller = ActionsViewController()
        let viewModel = ActionsViewModel()
        controller.viewModel = viewModel
        
        viewModel.output.actionDetail
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { actionId in
                self.showActionDetail(with: actionId)
            })
            .disposed(by: viewModel.bag)
        
        viewModel.output.feedback
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { _ in
                self.showFeedback()
            })
            .disposed(by: viewModel.bag)
                
        return controller
    }
}

//MARK: Private
extension ActionsCoordinator {
    private func showActionDetail(with id: String) {
        let presentingNavController = UINavigationController()
        let coord = ActionCoordinator(actionId: id, navController: presentingNavController)
        let controller = coord.startController()
        coord.output.close
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak presentingNavController] _ in
                presentingNavController?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: coord.bag)
        
        presentingNavController.setViewControllers([controller], animated: false)
        present(controller: presentingNavController, for: coord)
    }
    
    private func showFeedback() {
        let presentingNavController = UINavigationController()
        let coord = FeedbackCoordinator(navController: presentingNavController)
        let controller = coord.startController()
        coord.output.close
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak presentingNavController] _ in
                presentingNavController?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: coord.bag)
        
        presentingNavController.setViewControllers([controller], animated: false)
        present(controller: presentingNavController, for: coord)
    }
}
