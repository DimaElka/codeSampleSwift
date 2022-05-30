//
//  ActionInfoView.swift
//  Mir
//
//  Created by Dmitry Rogov on 08.12.2021.
//

import UIKit
import RxCocoa

class ActionInfoView: BaseView {
    //MARK: Properties
    private var rulesInfoItem: ActionInfoItemView!
    private var siteInfoItem: ActionInfoItemView!

    var rulesSelectTrigger: ControlEvent<Void> { rulesInfoItem.selectTrigger }
    var siteSelectTrigger: ControlEvent<Void> { siteInfoItem.selectTrigger }

    //MARK: - LifeCycle
    override func initialSetup() {
        makeUI()
    }        
}

//MARK: - UI
extension ActionInfoView {
    private func makeUI() {
        let titleLabel = UILabel()
        titleLabel.text = "Информация"
        titleLabel.font = .appFont(style: .medium, size: 22)
        titleLabel.textColor = .color(named: .text)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().inset(16)
        }
        
        rulesInfoItem = ActionInfoItemView()
        rulesInfoItem.configure(title: "Правила", image: .image(named: .rulesIcon))
        addSubview(rulesInfoItem)
        rulesInfoItem.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview()
        }
        
        let infoSeparatorView = UIView()
        infoSeparatorView.backgroundColor = UIColor.color(named: .border)
        addSubview(infoSeparatorView)
        infoSeparatorView.snp.makeConstraints {
            $0.top.equalTo(rulesInfoItem.snp.bottom)
            $0.left.equalToSuperview().offset(72)
            $0.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        siteInfoItem = ActionInfoItemView()
        siteInfoItem.configure(title: "Сайт партнера", image: .image(named: .siteIcon))
        addSubview(siteInfoItem)
        siteInfoItem.snp.makeConstraints {
            $0.top.equalTo(infoSeparatorView.snp.bottom).offset(16)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
