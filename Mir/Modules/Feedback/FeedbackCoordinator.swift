//
//  FeedbackCoordinator.swift
//  Mir
//
//  Created by Dmitry Rogov on 07.12.2021.
//

import UIKit
import RxSwift
import RxRelay

class FeedbackCoordinator: BaseCoordinator {
    struct Output {
        let close = PublishRelay<Void>()
    }
    
    let output = Output()
}

//MARK: Input
extension FeedbackCoordinator {
    func startController() -> UIViewController {
        let controller = FeedbackViewController()
        let viewModel = FeedbackViewModel()
        controller.viewModel = viewModel
        
        viewModel.output.close
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { _ in
                self.output.close.accept(())
            })
            .disposed(by: viewModel.bag)

        viewModel.output.success
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { email in
                self.showSuccess(with: email)
            })
            .disposed(by: viewModel.bag)
                
        return controller
    }
}

//MARK: Private
extension FeedbackCoordinator {
    private func showSuccess(with email: String) {
        let controller = FeedbackSuccessViewController()
        controller.email = email
        
        controller.output.close
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { _ in
                self.output.close.accept(())
            })
            .disposed(by: controller.bag)

        navController?.popViewController(animated: false)
        navController?.pushViewController(controller, animated: true)
    }
}
