//
//  ActionTitleView.swift
//  Mir
//
//  Created by Dmitry Rogov on 07.12.2021.
//

import UIKit

class ActionTitleView: BaseView {
    //MARK: Properties
    private var actionImageView: UIImageView!
    private var nameLabel: UILabel!
    private var categoryLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var markerView: UIView!
    private var markerLabel: UILabel!
    
    //MARK: - LifeCycle
    override func initialSetup() {
        makeUI()
    }
        
    //MARK: - Functions
    func configure(with action: Action) {
        nameLabel.text = action.name
        categoryLabel.text = action.category
        descriptionLabel.text = action.description
        markerLabel.text = action.marker
        actionImageView.image = UIImage(named: action.image) ?? .image(named: .actionImagePlaceholder)
    }
}

//MARK: - UI
extension ActionTitleView {
    private func makeUI() {
        let titleView = UIView()
        addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().inset(16)
        }
        
        actionImageView = UIImageView()
        actionImageView.roundCorners(with: 12)
        actionImageView.contentMode = .scaleAspectFit
        titleView.addSubview(actionImageView)
        actionImageView.snp.makeConstraints {
            $0.top.left.equalToSuperview()
            $0.width.height.equalTo(52)
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        nameLabel = UILabel()
        nameLabel.font = .appFont(style: .medium, size: 20)
        nameLabel.textColor = .color(named: .text)
        nameLabel.numberOfLines = 0
        titleView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalTo(actionImageView.snp.right).offset(16)
            $0.right.equalToSuperview()
        }
        
        categoryLabel = UILabel()
        categoryLabel.font = .appFont(style: .regular, size: 12)
        categoryLabel.textColor = .color(named: .textSecondary)
        titleView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(0)
            $0.left.equalTo(actionImageView.snp.right).offset(16)
            $0.right.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }

        descriptionLabel = UILabel()
        descriptionLabel.font = .appFont(style: .regular, size: 17)
        descriptionLabel.textColor = .color(named: .text)
        descriptionLabel.numberOfLines = 0
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(12)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().inset(16)
        }
        
        markerView = UIView()
        markerView.backgroundColor = .color(named: .mainLight)
        markerView.roundCorners(with: 10)
        addSubview(markerView)
        markerView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview()
        }
        
        markerLabel = UILabel()
        markerLabel.font = .appFont(style: .medium, size: 13)
        markerLabel.textColor = .color(named: .main)
        markerView.addSubview(markerLabel)
        markerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.left.equalToSuperview().offset(8)
            $0.right.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(4)
        }
    }
}
