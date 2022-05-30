//
//  UIViewController+Keyboard.swift
//  Mir
//
//  Created by Dmitry Rogov on 08.12.2021.
//

import Foundation
import RxSwift

extension Reactive where Base: UIViewController {
    func keyboardWillShow() -> Observable<CGFloat> {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification, object: nil)
            .map { notification in
                let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
                return keyboardFrame?.cgRectValue.height
            }
            .compactMap({$0})
    }
    
    func keyboardWillHide() -> Observable<Void> {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification, object: nil)
            .map { _ in Void() }
    }
}
