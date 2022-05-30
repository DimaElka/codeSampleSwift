//
//  MIRTextField.swift
//  Mir
//
//  Created by Dmitry Rogov on 07.12.2021.
//

import UIKit
import RxSwift
import RxCocoa

class MIRTextField: BaseView {
    // MARK: - Properties
    //UI
    private var textFieldView: UIView!
    private var titleLabel: UILabel!
    private var textField: UITextField!
    private var bottomLineView: UIView!
    private var errorLabel: UILabel!
    
    //Private
    private let activeColor: UIColor = .color(named: .textFieldActiveTint)
    private let inactiveColor: UIColor = .color(named: .textFieldInactiveTint)
    private let errorColor: UIColor = .color(named: .textFieldError)
    
    private let activeTitleOffset: CGFloat = 5
    private let unactiveTitleOffset: CGFloat = 20
    
    private var viewModel: MIRTextFieldViewModel?
    private var isActive: Bool = false
    
    // MARK: - Lifecycle
    override func initialSetup() {
        makeUI()
        subscribe()
                
        changeActive(false, animated: false)
    }
}

//MARK: - Input
extension MIRTextField {
    func configure(title: String, viewModel: MIRTextFieldViewModel) {
        self.viewModel = viewModel
        
        titleLabel.text = title
        textField.keyboardType = viewModel.keyboardType
        textField.textContentType = viewModel.contentType

        subscribe(viewModel: viewModel)
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }
}

// MARK: - Subscriptions
extension MIRTextField {
    private func subscribe() {
        textField.rx.controlEvent(.editingDidEnd)
            .subscribe(with: self, onNext: { owner, _ in
                owner.changeActive(false)
            })
            .disposed(by: bag)
        
        textField.rx.controlEvent(.editingDidBegin)
            .subscribe(with: self,onNext: { owner, _ in
                owner.changeActive(true)
            })
            .disposed(by: bag)
                
        textField.rx.text
            .map({ ($0 ?? "").isEmpty })
            .distinctUntilChanged()
            .subscribe(with: self, onNext: { owner, isTextEmpty in
                if !isTextEmpty {
                    owner.changeHintActive(true)
                } else {
                    owner.changeHintActive(owner.isActive)
                }
            })
            .disposed(by: bag)
    }
    
    private func subscribe(viewModel: MIRTextFieldViewModel) {
        textField.rx.controlEvent(.editingDidEnd)
            .bind(to: viewModel.endEditingTrigger)
            .disposed(by: viewModel.bag)

        textField.rx.controlEvent(.editingChanged)
            .withLatestFrom(textField.rx.text)
            .map({ $0 ?? "" })
            .bind(to: viewModel.textChangedTrigger)
            .disposed(by: viewModel.bag)

        viewModel.text
            .bind(to: textField.rx.text)
            .disposed(by: viewModel.bag)
                
        viewModel.error
            .distinctUntilChanged()
            .subscribe(with: self, onNext: { owner, error in
                owner.changeError(error)
            })
            .disposed(by: viewModel.bag)
    }
}
// MARK: - States
extension MIRTextField {
    private func changeActive(_ isActive: Bool, animated: Bool = true) {
        self.isActive = isActive
        bottomLineView.backgroundColor = isActive ? activeColor : inactiveColor
        
        if !(textField.text ?? "").isEmpty {
            changeHintActive(true, animated: animated)
        } else {
            changeHintActive(isActive, animated: animated)
        }
    }
    
    private func changeHintActive(_ isActive: Bool, animated: Bool = true) {
        titleLabel.font = .appFont(style: .regular, size: isActive ? 12 : 15)
        titleLabel.snp.updateConstraints {
            $0.top.equalToSuperview().offset(isActive ? activeTitleOffset : unactiveTitleOffset)
        }
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }
    
    private func changeError(_ error: String?) {
        if let error = error {
            bottomLineView.backgroundColor = errorColor
            errorLabel.text = error
        } else {
            bottomLineView.backgroundColor = isActive ? activeColor : inactiveColor
            errorLabel.text = nil
        }
    }
}

// MARK: - UI
extension MIRTextField {
    private func makeUI() {
        backgroundColor = .clear
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        textFieldView = UIView()
        stackView.addArrangedSubview(textFieldView)
        
        titleLabel = UILabel()
        titleLabel.textColor = .color(named: .textSecondary)
        titleLabel.font = .appFont(style: .regular, size: 15)
        titleLabel.isUserInteractionEnabled = false
        textFieldView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(unactiveTitleOffset)
            $0.left.right.equalToSuperview()
        }
        
        textField = UITextField()
        textField.textColor = .color(named: .text)
        textField.borderStyle = .none
        textField.font = .appFont(style: .regular, size: 15)
        textField.tintColor = activeColor
        textFieldView.addSubview(textField)
        textField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.left.equalToSuperview()
            $0.bottom.equalToSuperview().inset(5)
            $0.right.equalToSuperview()
        }
        
        bottomLineView = UIView()
        textFieldView.addSubview(bottomLineView)
        bottomLineView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
                
        errorLabel = UILabel()
        errorLabel.font = .appFont(style: .regular, size: 12)
        errorLabel.textColor = errorColor
        stackView.addArrangedSubview(errorLabel)
    }
}
