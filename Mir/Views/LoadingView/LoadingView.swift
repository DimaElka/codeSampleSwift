//
//  LoadingView.swift
//  Mir
//
//  Created by Dmitry Rogov on 08.12.2021.
//

import UIKit

class LoadingView: BaseView {
    //MARK: - Properties
    private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func initialSetup() {
        makeUI()
        
        activityIndicator.startAnimating()
    }
}

extension LoadingView {
    private func makeUI() {
        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView(style: .large)
        } else {
            activityIndicator = UIActivityIndicatorView()
        }
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
