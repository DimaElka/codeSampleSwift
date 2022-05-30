//
//  ActionViewModel.swift
//  Mir
//
//  Created by Dmitry Rogov on 07.12.2021.
//

import Foundation
import RxSwift
import RxRelay

class ActionViewModel: BaseViewModel {
    struct Output {
        let close = PublishRelay<Void>()
        let feedback = PublishRelay<Void>()
    }
    
    //MARK: - Properties
    //Output
    let output = Output()
    let action = BehaviorRelay<Action?>(value: nil)
    let isLoading = BehaviorRelay<Bool>(value: true)
    
    //Private
    let actionId: String
    
    //MARK: - Setup
    init(actionId: String) {
        self.actionId = actionId
        super.init()
        
        subscribe()
        loadAction()
    }
    
    private func subscribe() {
    }
}

//MARK: - Private
extension ActionViewModel {
    func loadAction() {
        isLoading.accept(true)
        NetworkManager.shared.actionsProvider.rx
            .request(.action(id: actionId))
            .map(Action.self, atKeyPath: "data", failsOnEmptyData: true)
            .subscribe(with: self, onSuccess: { owner, action in
                owner.action.accept(action)
                owner.isLoading.accept(false)
            }, onFailure: { owner, error in
                owner.isLoading.accept(false)
                //handle error
            })
            .disposed(by: bag)
    }
}
