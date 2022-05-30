//
//  ActionViewController.swift
//  Mir
//
//  Created by Dmitry Rogov on 07.12.2021.
//

import UIKit
import RxSwift
import RxCocoa

class ActionViewController: BaseViewController {
    //MARK: - Properties
    private var closeButton: UIButton!
    
    private var loadingView: LoadingView!
    
    private var scrollView: UIScrollView!
    private var titleView: ActionTitleView!
    private var generalView: ActionGeneralView!
    private var infoView: ActionInfoView!
    
    private var feedbackButton: UIButton!

    var viewModel: ActionViewModel!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        subscribe()
        subscribeViewModel()
    }
}

//MARK: - Subscriptions
extension ActionViewController {
    func subscribe() {
        closeButton.rx.tap
            .bind(to: viewModel.output.close)
            .disposed(by: bag)
        
        feedbackButton.rx.tap
            .bind(to: viewModel.output.feedback)
            .disposed(by: bag)
    }
    
    func subscribeViewModel() {
        viewModel.action
            .asDriver()
            .compactMap({$0})
            .drive(with: self, onNext: { owner, action in
                owner.titleView.configure(with: action)
                owner.generalView.configure(with: action)
            })
            .disposed(by: viewModel.bag)
        
        viewModel.isLoading
            .asDriver()
            .drive(with: self, onNext: { owner, isLoading in
                owner.showLoading(isLoading)
            })
            .disposed(by: viewModel.bag)
    }
}

//MARK: - Private
extension ActionViewController {
    private func showLoading(_ isLoading: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.loadingView.alpha = isLoading ? 1.0 : 0.0
        }
    }
}

//MARK: - UI
extension ActionViewController {
    private func makeUI() {
        view.backgroundColor = .color(named: .background)
        navigationController?.isNavigationBarHidden = true
        
        closeButton = UIButton()
        closeButton.setTitle(nil, for: .normal)
        closeButton.setImage(.image(named: .closeIcon), for: .normal)
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.right.equalToSuperview().inset(16)
        }
        
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        let scrollContentView = UIView()
        scrollView.addSubview(scrollContentView)
        scrollContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        let scrollStackView = UIStackView()
        scrollStackView.axis = .vertical
        scrollStackView.alignment = .fill
        scrollStackView.distribution = .equalSpacing
        scrollStackView.spacing = 16
        scrollContentView.addSubview(scrollStackView)
        scrollStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleView = ActionTitleView()
        scrollStackView.addArrangedSubview(titleView)
                
        generalView = ActionGeneralView()
        scrollStackView.addArrangedSubview(generalView)
        
        infoView = ActionInfoView()
        scrollStackView.addArrangedSubview(infoView)
        
        loadingView = LoadingView()
        loadingView.backgroundColor = .color(named: .background)
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    
        feedbackButton = UIButton()
        feedbackButton.setTitle(nil, for: .normal)
        feedbackButton.setImage(.image(named: .feedbackIcon), for: .normal)
        feedbackButton.backgroundColor = .color(named: .main)
        feedbackButton.roundCorners(with: 26)
        view.addSubview(feedbackButton)
        feedbackButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(42)
            $0.width.height.equalTo(52)
        }
    }
}
