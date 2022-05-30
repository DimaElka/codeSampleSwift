//
//  ActionCoordinator.swift
//  Mir
//
//  Created by Dmitry Rogov on 07.12.2021.
//

import UIKit
import RxSwift
import RxRelay

class ActionCoordinator: BaseCoordinator {
    struct Output {
        let close = PublishRelay<Void>()
    }
    
    let output = Output()
    private let actionId: String
    
    init(actionId: String, navController: UINavigationController) {
        self.actionId = actionId
        super.init(navController: navController)
    }
}

//MARK: Input
extension ActionCoordinator {
    func startController() -> UIViewController {
        let controller = ActionViewController()
        let viewModel = ActionViewModel(actionId: actionId)
        controller.viewModel = viewModel
        
        viewModel.output.close
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { _ in
                self.output.close.accept(())
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
extension ActionCoordinator {
    private func showFeedback() {
        let presentingNavController = UINavigationController()
        let coord = FeedbackCoordinator(navController: presentingNavController)
        let controller = coord.startController()
        coord.output.close
            .bind(onNext: { [weak presentingNavController] _ in
                presentingNavController?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: coord.bag)
        
        presentingNavController.setViewControllers([controller], animated: false)
        present(controller: presentingNavController, for: coord)
    }
}
