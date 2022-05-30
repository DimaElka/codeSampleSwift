//
//  FeedbackViewController.swift
//  Mir
//
//  Created by Dmitry Rogov on 07.12.2021.
//

import UIKit
import RxSwift
import RxCocoa

class FeedbackViewController: BaseViewController {
    //MARK: - Properties
    private var closeButton: UIButton!
    private var scrollView: UIScrollView!
    private var emailTextField: MIRTextField!
    private var themeTextField: MIRTextField!
    private var messageTextField: MIRTextView!
    private var loadingView: LoadingView!
    private var sendButton: UIButton!
    
    private var viewTapRecognizer: UITapGestureRecognizer!

    var viewModel: FeedbackViewModel!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        subscribe()
        subscribeViewModel()
        
        emailTextField.becomeFirstResponder()
    }
}

//MARK: - Subscriptions
extension FeedbackViewController {
    func subscribe() {
        closeButton.rx.tap
            .bind(to: viewModel.output.close)
            .disposed(by: bag)
        
        viewTapRecognizer.rx.event
            .bind(with: self) { owner, _ in
                owner.view.endEditing(true)
            }
            .disposed(by: bag)
        
        rx.keyboardWillShow()
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self, onNext: { owner, keyboardHeight in
                owner.scrollView.contentInset.bottom = keyboardHeight + 20
            })
            .disposed(by: bag)
        
        rx.keyboardWillHide()
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self, onNext: { owner, _ in
                owner.scrollView.contentInset.bottom = owner.safeAreaBottomInset
            })
            .disposed(by: bag)
        
        sendButton.rx.tap
            .do(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .bind(to: viewModel.sendTrigger)
            .disposed(by: bag)
    }
    
    func subscribeViewModel() {
        viewModel.isSendEnabled
            .asDriver()
            .drive(with: self, onNext: { owner, isSendEnabled in
                owner.changeSendEnabled(isSendEnabled)
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
extension FeedbackViewController {
    private func changeSendEnabled(_ isEnabled: Bool) {
        sendButton.setTitleColor(.color(named: isEnabled ? .buttonActiveTitle : .buttonDisabledTitle), for: .normal)
        sendButton.backgroundColor = .color(named: isEnabled ? .buttonActiveBackground : .buttonDisabledBackground)
        sendButton.isUserInteractionEnabled = isEnabled
    }
    
    private func showLoading(_ isLoading: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.loadingView.alpha = isLoading ? 1.0 : 0.0
        }
    }
}

//MARK: - UI
extension FeedbackViewController {
    private func makeUI() {
        view.backgroundColor = .color(named: .background)
        navigationController?.isNavigationBarHidden = true
        
        viewTapRecognizer = UITapGestureRecognizer()
        viewTapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(viewTapRecognizer)

        closeButton = UIButton()
        closeButton.setTitle(nil, for: .normal)
        closeButton.setImage(.image(named: .closeIcon), for: .normal)
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.right.equalToSuperview().inset(16)
        }
        
        scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .onDrag
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
        
        let titleLabel = UILabel()
        titleLabel.text = "Напишите нам!"
        titleLabel.font = .appFont(style: .medium, size: 34)
        titleLabel.textColor = .color(named: .text)
        scrollContentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().inset(20)
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        scrollContentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().inset(20)
        }
        
        emailTextField = MIRTextField()
        emailTextField.configure(title: "E-mail", viewModel: viewModel.emailViewModel)
        stackView.addArrangedSubview(emailTextField)
        
        themeTextField = MIRTextField()
        themeTextField.configure(title: "Тема обращения", viewModel: viewModel.themeViewModel)
        stackView.addArrangedSubview(themeTextField)
        
        messageTextField = MIRTextView()
        messageTextField.configure(title: "Сообщение", viewModel: viewModel.messageViewModel)
        stackView.addArrangedSubview(messageTextField)
        
        sendButton = UIButton()
        sendButton.backgroundColor = .color(named: .buttonActiveBackground)
        sendButton.setTitleColor(.color(named: .buttonActiveTitle), for: .normal)
        sendButton.setTitle("Отправить", for: .normal)
        sendButton.roundCorners(with: 25)
        scrollContentView.addSubview(sendButton)
        sendButton.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(36)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(50)
            $0.width.equalTo(210)
        }
        
        loadingView = LoadingView()
        loadingView.backgroundColor = .color(named: .background).withAlphaComponent(0.5)
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}
