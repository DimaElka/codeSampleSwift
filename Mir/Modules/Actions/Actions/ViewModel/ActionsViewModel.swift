//
//  ActionsViewModel.swift
//  Mir
//
//  Created by Dmitry Rogov on 06.12.2021.
//

import Foundation
import RxSwift
import RxRelay
import RxDataSources

class ActionsViewModel: BaseViewModel {
    struct Output {
        let actionDetail = PublishRelay<String>()
        let feedback = PublishRelay<Void>()
    }
    
    //MARK: - Propertioes
    //Output
    let output = Output()
    let items = BehaviorRelay<[ItemModel]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let isMoreLoading = BehaviorRelay<Bool>(value: false)

    //Input
    let itemSelectedTrigger = PublishRelay<ItemModel>()
    let loadMoreTrigger = PublishRelay<Void>()
    
    //Private
    var currentPage = 0
    let itemsPerPage = 10
    
    var _isLoading: Bool { isLoading.value }
    var _isMoreLoading: Bool { isMoreLoading.value }
    var isAllLoaded = false
    
    //MARK: - Setup
    override init() {
        super.init()
        subscribe()
        loadItems()
    }
    
    private func subscribe() {
        itemSelectedTrigger
            .map(\.action.id)
            .bind(to: output.actionDetail)
            .disposed(by: bag)
        
        loadMoreTrigger
            .subscribe(with: self, onNext: { owner, _ in
                owner.loadMore()
            })
            .disposed(by: bag)
    }
}

//MARK: - Private
extension ActionsViewModel {
    private func loadItems() {
        currentPage = 0
        isMoreLoading.accept(false)
        isAllLoaded = false
        items.accept([])
        
        isLoading.accept(true)
        NetworkManager.shared.actionsProvider.rx
            .request(.actions(page: currentPage))
            .map([Action].self, atKeyPath: "data", failsOnEmptyData: true)
            .subscribe(with: self, onSuccess: { owner, actions in
                owner.configureItems(from: actions)
                owner.isAllLoaded = actions.count < owner.itemsPerPage
                owner.currentPage += 1
                owner.isLoading.accept(false)
            }, onFailure: { owner, error in
                owner.isLoading.accept(false)
                //handle error
            })
            .disposed(by: bag)
    }
    
    private func loadMore() {
        guard !_isMoreLoading && !_isLoading && !isAllLoaded else { return }
        
        isMoreLoading.accept(true)
        let currentPage = currentPage
        NetworkManager.shared.actionsProvider.rx
            .request(.actions(page: currentPage + 1))
            .map([Action].self, atKeyPath: "data", failsOnEmptyData: true)
            .subscribe(with: self, onSuccess: { owner, actions in
                guard owner.currentPage == currentPage else {
                    owner.isMoreLoading.accept(false)
                    return
                }
                
                owner.appendItems(from: actions)
                owner.isAllLoaded = actions.count < owner.itemsPerPage
                owner.currentPage += 1
                owner.isMoreLoading.accept(false)
            }, onFailure: { owner, error in
                owner.isMoreLoading.accept(false)
                //handle error
            })
            .disposed(by: bag)
    }
}

//MARK: - DataSource
extension ActionsViewModel {
    struct ItemModel: RxDataSources.IdentifiableType, Equatable {
        let action: Action
        
        var identity: String {
            return action.id
        }
    }
    
    private func configureItems(from actions: [Action]) {
        let items: [ItemModel] = actions.map { ItemModel(action: $0) }
        self.items.accept(items)
    }
    
    private func appendItems(from actions: [Action]) {
        let items: [ItemModel] = actions.map { ItemModel(action: $0) }
        let allItems = self.items.value + items
        self.items.accept(allItems)
    }
}

