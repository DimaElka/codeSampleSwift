//
//  FeedbackViewModel.swift
//  Mir
//
//  Created by Dmitry Rogov on 07.12.2021.
//

import Foundation
import RxSwift
import RxRelay

class FeedbackViewModel: BaseViewModel {
    struct Output {
        let close = PublishRelay<Void>()
        let success = PublishRelay<String>()
    }
    
    //MARK: - Properties
    //Output
    let output = Output()
    
    let emailViewModel: MIRTextFieldViewModel
    let themeViewModel: MIRTextFieldViewModel
    let messageViewModel: MIRTextFieldViewModel
    
    let isSendEnabled = BehaviorRelay<Bool>(value: false)
    let isLoading = BehaviorRelay<Bool>(value: false)

    //Input
    let sendTrigger = PublishRelay<Void>()
    
    //Private
    let isEmailValid = BehaviorRelay<Bool>(value: false)
    let isThemeValid = BehaviorRelay<Bool>(value: false)
    let isMessageValid = BehaviorRelay<Bool>(value: false)
    
    //MARK: - Setup
    override init() {
        emailViewModel = MIRTextFieldViewModel(type: .email, maxCount: 30)
        themeViewModel = MIRTextFieldViewModel(maxCount: 30)
        messageViewModel = MIRTextFieldViewModel(maxCount: 100)
        
        super.init()
        
        subscribe()
    }
    
    private func subscribe() {
        emailViewModel.textChangedTrigger
            .withLatestFrom(emailViewModel.text)
            .withUnretained(emailViewModel)
            .map({ viewModel, text in
                guard !text.isEmpty else {
                    viewModel.showError("Вы не указали e-mail")
                    return false
                }
                guard text.isValidEmail() else {
                    viewModel.showError("Не верно указан e-mail")
                    return false
                }
                
                return true
            })
            .bind(to: isEmailValid)
            .disposed(by: bag)
        
        themeViewModel.textChangedTrigger
            .withLatestFrom(themeViewModel.text)
            .withUnretained(themeViewModel)
            .map({ viewModel, text in
                guard !text.isEmpty else {
                    viewModel.showError("Вы не указали тему обращения")
                    return false
                }
                
                return true
            })
            .bind(to: isThemeValid)
            .disposed(by: bag)
        
        messageViewModel.textChangedTrigger
            .withLatestFrom(messageViewModel.text)
            .withUnretained(messageViewModel)
            .map({ viewModel, text in
                guard !text.isEmpty else {
                    viewModel.showError("Вы не указали сообщение")
                    return false
                }
                
                return true
            })
            .bind(to: isMessageValid)
            .disposed(by: bag)
        
        Observable.combineLatest(isEmailValid, isThemeValid, isMessageValid)
            .map { isEmailValid, isThemeValid, isMessageValid in
                return isEmailValid && isThemeValid && isMessageValid
            }
            .bind(to: isSendEnabled)
            .disposed(by: bag)
        
        sendTrigger
            .subscribe(with: self, onNext: { owner, _ in
                owner.shouldSend()
            })
            .disposed(by: bag)
    }
}

//MARK: - Private
extension FeedbackViewModel {
    private func shouldSend() {
        let feedback = Feedback(email: emailViewModel.text.value,
                                theme: themeViewModel.text.value,
                                message: messageViewModel.text.value)
        
        isLoading.accept(true)
        NetworkManager.shared.actionsProvider.rx
            .request(.feedback(feedback: feedback))
            .subscribe(with: self, onSuccess: { owner, _ in
                owner.output.success.accept(feedback.email)
                owner.isLoading.accept(false)
            }, onFailure: { owner, error in
                owner.isLoading.accept(false)
                //handle error
            })
            .disposed(by: bag)
    }
}
