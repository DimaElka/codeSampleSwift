//
//  MIRTextFieldViewModel.swift
//  Mir
//
//  Created by Dmitry Rogov on 07.12.2021.
//

import UIKit
import RxSwift
import RxCocoa

class MIRTextFieldViewModel {
    struct Output {
        let textChanged = PublishRelay<Void>()
        let endEditing = PublishRelay<Void>()
    }
    
    enum TextFieldType {
        case normal
        case email
    }
    
    //MARK: - Properies
    //Output
    var output = Output()
    let bag = DisposeBag()
    
    var text = BehaviorRelay<String>(value: "")
    var error = BehaviorRelay<String?>(value: nil)
    
    var keyboardType: UIKeyboardType = UIKeyboardType.default
    var contentType: UITextContentType? = nil
    
    //Input
    var textChangedTrigger = PublishRelay<String>()
    var endEditingTrigger = PublishRelay<Void>()

    //Private
    private let type: TextFieldType
    private let maxCount: Int?
    
    //MARK: - Lifecycle
    init(text: String? = nil, type: TextFieldType = .normal, maxCount: Int? = nil) {
        self.type = type
        self.maxCount = maxCount
        
        self.text.accept(formatText(text ?? ""))
        
        configureType()
        subscribe()
    }
    
    private func subscribe() {
        textChangedTrigger
            .subscribe(with: self, onNext: { owner, text in
                owner.error.accept(nil)
                let formattedText = owner.formatText(text)
                owner.text.accept(formattedText)
                owner.output.textChanged.accept(())
            })
            .disposed(by: bag)
        
        endEditingTrigger
            .withLatestFrom(text)
            .subscribe(with: self, onNext: { owner, text in
                let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
                owner.textChangedTrigger.accept(trimmedText)
                owner.output.endEditing.accept(())
            })
            .disposed(by: bag)
    }
    
    //MARK: - Private
    private func formatText(_ text: String) -> String {
        var formattedText = text
        if let maxCount = maxCount,
           formattedText.count > maxCount {
            formattedText = String(formattedText.prefix(maxCount))
        }
        
        return formattedText
    }
    
    private func configureType() {
        switch type {
        case .normal: break
        case .email:
            keyboardType = .emailAddress
            contentType = .emailAddress
        }
    }
    
    //MARK: - Input
    func showError(_ errorText: String?) {
        error.accept(errorText)
    }
    
    func updateText(_ text: String?) {
        self.textChangedTrigger.accept(text ?? "")
    }
}
