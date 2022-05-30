//
//  BaseCollectionView.swift
//  Mir
//
//  Created by Dmitry Rogov on 06.12.2021.
//

import UIKit
import RxSwift

class BaseCollectionView: UICollectionView {
    var footerView: UIView? {
        get {
            footerContainerView.subviews.first
        }
        set {
            footerBag = DisposeBag()
            if let oldFooter = footerContainerView.subviews.first {
                oldFooter.removeFromSuperview()
                contentInset.bottom -= oldFooter.bounds.height
            }

            guard let newValue = newValue else { return }
            addFooter(newValue)
        }
    }
    
    private lazy var footerContainerView: UIView = {
        let footerContainerView = UIView(frame: CGRect(x: 0, y: contentSize.height, width: bounds.width, height: 0))
        footerContainerView.translatesAutoresizingMaskIntoConstraints = true
        footerContainerView.autoresizingMask = [.flexibleWidth]
        addSubview(footerContainerView)
        return footerContainerView
    }()
    
    private var footerBag = DisposeBag()
}

extension BaseCollectionView {
    func addFooter(_ footerView: UIView) {
        var currentFooterHeight: CGFloat = 0
        footerContainerView.bounds.size.height = currentFooterHeight
        
        footerContainerView.addSubview(footerView)
        footerView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
                
        self.rx.observe(CGSize.self, #keyPath(UICollectionView.contentSize))
            .compactMap({$0})
            .subscribe(with: self, onNext: { collectionView, newContentSize in
                collectionView.footerContainerView.frame.origin = CGPoint(x: 0, y: newContentSize.height)
            })
            .disposed(by: footerBag)
        
        let footerHeight = footerView.rx
            .observe(CGRect.self, #keyPath(UIView.bounds))
            .compactMap({$0})
            .map(\.size.height)
        
        let footerIsHidden = footerView.rx
            .observe(Bool.self, #keyPath(UIView.isHidden))
            .compactMap({$0})

        Observable.combineLatest(footerIsHidden, footerHeight)
            .subscribe(onNext: { [weak self] isHidden, footerHeight in
                let newFooterHeight = isHidden ? 0.0 : footerHeight
                guard newFooterHeight != currentFooterHeight else { return }
                let footerDiff = newFooterHeight - currentFooterHeight
                currentFooterHeight = newFooterHeight
                self?.contentInset.bottom += footerDiff
            })
            .disposed(by: footerBag)
    }
}
