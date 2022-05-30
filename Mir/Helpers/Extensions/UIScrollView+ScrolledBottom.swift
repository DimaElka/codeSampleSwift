//
//  UIScrollView+ScrolledBottom.swift
//  Mir
//
//  Created by Dmitry Rogov on 07.12.2021.
//

import UIKit
import RxSwift

public extension UIScrollView {
    func isScrolledToBottom(offset: CGFloat = 0.0) -> Bool {
        return contentOffset.y + self.frame.size.height >= self.contentSize.height - offset
    }
}

extension Reactive where Base: UIScrollView {
    func nearBottom(offset: CGFloat) -> Observable<Void> {
        return self.contentOffset
            .withUnretained(self.base)
            .map({ scrollView, contentOffset in
                guard scrollView.contentSize.height != 0.0,
                      scrollView.isScrolledToBottom(offset: offset) else {
                          return false
                      }
                
                return true
            })
            .distinctUntilChanged()
            .flatMap { isNearBottom in
                return isNearBottom ? Observable.just(()) : Observable.empty()
            }
    }
}
