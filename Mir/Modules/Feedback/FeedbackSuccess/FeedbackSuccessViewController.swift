//
//  FeedbackSuccessViewController.swift
//  Mir
//
//  Created by Dmitry Rogov on 08.12.2021.
//

import UIKit
import RxSwift
import RxCocoa

class FeedbackSuccessViewController: BaseViewController {
    struct Output {
        let close = PublishRelay<Void>()
    }
    
    //MARK: - Properties
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!
    private var subtitleEmailLabel: UILabel!
    private var closeButton: UIButton!
    
    let output = Output()
    var email: String!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        subscribe()
    }
}

//MARK: - Subscriptions
extension FeedbackSuccessViewController {
    func subscribe() {
        closeButton.rx.tap
            .bind(to: output.close)
            .disposed(by: bag)
    }
}

//MARK: - UI
extension FeedbackSuccessViewController {
    private func makeUI() {
        view.backgroundColor = .color(named: .background)
        navigationController?.isNavigationBarHidden = true
        
        let contentView = UIView()
        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        titleLabel = UILabel()
        titleLabel.text = "Спасибо за обращение!"
        titleLabel.font = .appFont(style: .medium, size: 34)
        titleLabel.textColor = .color(named: .text)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
        
        subtitleLabel = UILabel()
        subtitleLabel.text = "Ответим вам в течении дня, ждите письмо на свою почту:"
        subtitleLabel.font = .appFont(style: .regular, size: 17)
        subtitleLabel.textColor = .color(named: .text)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview()
        }
        
        subtitleEmailLabel = UILabel()
        subtitleEmailLabel.text = email
        subtitleEmailLabel.font = .appFont(style: .medium, size: 17)
        subtitleEmailLabel.textColor = .color(named: .text)
        subtitleEmailLabel.numberOfLines = 0
        subtitleEmailLabel.textAlignment = .center
        contentView.addSubview(subtitleEmailLabel)
        subtitleEmailLabel.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom)
            $0.left.right.equalToSuperview()
        }
        
        closeButton = UIButton()
        closeButton.backgroundColor = .color(named: .buttonActiveBackground)
        closeButton.setTitleColor(.color(named: .buttonActiveTitle), for: .normal)
        closeButton.setTitle("Спасибо", for: .normal)
        closeButton.roundCorners(with: 25)
        contentView.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalTo(subtitleEmailLabel.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalTo(210)
        }
    }
}
