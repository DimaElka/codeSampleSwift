//
//  ActionGeneralView.swift
//  Mir
//
//  Created by Dmitry Rogov on 07.12.2021.
//

import UIKit

class ActionGeneralView: BaseView {
    //MARK: Properties
    private var conditionsLabel: UILabel!
    private var dateLabel: UILabel!
    
    //MARK: - LifeCycle
    override func initialSetup() {
        makeUI()
    }
        
    //MARK: - Functions
    func configure(with action: Action) {
        conditionsLabel.text = action.conditions
        dateLabel.text = action.date
    }
}

//MARK: - UI
extension ActionGeneralView {
    private func makeUI() {
        let titleLabel = UILabel()
        titleLabel.text = "Общие сведения"
        titleLabel.font = .appFont(style: .medium, size: 22)
        titleLabel.textColor = .color(named: .text)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().inset(16)
        }
        
        let contentView = UIView()
        contentView.backgroundColor = .color(named: .mainLight)
        contentView.roundCorners(with: 12)
        addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 8
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        let conditionsStackView = UIStackView()
        conditionsStackView.axis = .vertical
        conditionsStackView.distribution = .equalSpacing
        conditionsStackView.alignment = .fill
        conditionsStackView.spacing = 2
        stackView.addArrangedSubview(conditionsStackView)
        
        let conditionsTitleLabel = UILabel()
        conditionsTitleLabel.text = "Условия акции"
        conditionsTitleLabel.font = .appFont(style: .medium, size: 15)
        conditionsTitleLabel.textColor = .color(named: .text)
        conditionsStackView.addArrangedSubview(conditionsTitleLabel)
        
        conditionsLabel = UILabel()
        conditionsLabel.font = .appFont(style: .regular, size: 15)
        conditionsLabel.textColor = .color(named: .text)
        conditionsLabel.numberOfLines = 0
        conditionsStackView.addArrangedSubview(conditionsLabel)
        
        let dateStackView = UIStackView()
        dateStackView.axis = .vertical
        dateStackView.distribution = .equalSpacing
        dateStackView.alignment = .fill
        dateStackView.spacing = 2
        stackView.addArrangedSubview(dateStackView)
        
        let dateTitleLabel = UILabel()
        dateTitleLabel.text = "Срок проведения"
        dateTitleLabel.font = .appFont(style: .medium, size: 15)
        dateTitleLabel.textColor = .color(named: .text)
        dateStackView.addArrangedSubview(dateTitleLabel)
        
        dateLabel = UILabel()
        dateLabel.font = .appFont(style: .regular, size: 15)
        dateLabel.textColor = .color(named: .text)
        dateLabel.numberOfLines = 0
        dateStackView.addArrangedSubview(dateLabel)
    }
}
