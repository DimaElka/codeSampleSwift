//
//  MIRTextView.swift
//  Mir
//
//  Created by Dmitry Rogov on 07.12.2021.
//

import UIKit
import RxSwift
import RxCocoa

class MIRTextView: BaseView {
    // MARK: - Properties
    //UI
    private var textFieldView: UIView!
    private var titleLabel: UILabel!
    private var textView: UITextView!
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
extension MIRTextView {
    func configure(title: String, viewModel: MIRTextFieldViewModel) {
        self.viewModel = viewModel
        
        titleLabel.text = title
        textView.keyboardType = viewModel.keyboardType
        textView.textContentType = viewModel.contentType

        subscribe(viewModel: viewModel)
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        textView.becomeFirstResponder()
    }
}

// MARK: - Subscriptions
extension MIRTextView {
    private func subscribe() {
        textView.rx.didEndEditing
            .subscribe(with: self, onNext: { owner, _ in
                owner.changeActive(false)
            })
            .disposed(by: bag)
        
        textView.rx.didBeginEditing
            .subscribe(with: self, onNext: { owner, _ in
                owner.changeActive(true)
            })
            .disposed(by: bag)
                
        textView.rx.text
            .map({ ($0 ?? "").isEmpty })
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isTextEmpty in
                if !isTextEmpty {
                    self?.changeHintActive(true)
                } else {
                    self?.changeHintActive(self?.isActive ?? false)
                }
            })
            .disposed(by: bag)
    }
    
    private func subscribe(viewModel: MIRTextFieldViewModel) {
        textView.rx.didEndEditing
            .bind(to: viewModel.endEditingTrigger)
            .disposed(by: viewModel.bag)

        textView.rx.didChange
        //textView.rx.text not updated in time, map manually
            .map({ [weak self] _ in
              return self?.textView.text ?? ""
            })
            .bind(to: viewModel.textChangedTrigger)
            .disposed(by: viewModel.bag)

        viewModel.text
            .bind(to: textView.rx.text)
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
extension MIRTextView {
    private func changeActive(_ isActive: Bool, animated: Bool = true) {
        self.isActive = isActive
        bottomLineView.backgroundColor = isActive ? activeColor : inactiveColor
        
        if !(textView.text ?? "").isEmpty {
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
            self.bottomLineView.backgroundColor = errorColor
            self.errorLabel.text = error
        } else {
            self.bottomLineView.backgroundColor = self.isActive ? activeColor : inactiveColor
            self.errorLabel.text = nil
        }
    }
}

// MARK: - UI
extension MIRTextView {
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
        
        textView = UITextView()
        textView.textColor = .color(named: .text)
        textView.font = .appFont(style: .regular, size: 15)
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textFieldView.addSubview(textView)
        textView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.left.equalToSuperview()
            $0.bottom.equalToSuperview().inset(5)
            $0.right.equalToSuperview()
            $0.height.greaterThanOrEqualTo(45)
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
