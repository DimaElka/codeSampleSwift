//
//  ActionsActionCell.swift
//  Mir
//
//  Created by Dmitry Rogov on 06.12.2021.
//

import UIKit
import SnapKit

class ActionsActionCell: BaseCollectionViewCell {
    //MARK: - Properties
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        actionImageView.image = nil
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
extension ActionsActionCell {
    private func makeUI() {
        contentView.backgroundColor = .clear
        
        let containerView = UIView()
        containerView.backgroundColor = .color(named: .background)
        containerView.roundCorners(with: 16)
        containerView.setupShadow(radius: 2.21, offset: CGSize(width: 0, height: 2.77))
        containerView.updateShadowColor(.color(named: .shadow))
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        let titleView = UIView()
        containerView.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
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
        containerView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(12)
            $0.top.greaterThanOrEqualTo(actionImageView.snp.bottom).offset(12)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().inset(16)
        }
        
        markerView = UIView()
        markerView.backgroundColor = .color(named: .mainLight)
        markerView.roundCorners(with: 10)
        containerView.addSubview(markerView)
        markerView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            $0.left.equalToSuperview().offset(16)
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

//MARK: - CellSize
extension ActionsActionCell {
    static func cellSize(for width: CGFloat, with action: Action) -> CGSize {
        let containerWidth = width - 16 - 16
        
        let imageHeight: CGFloat = 52
        let imageWidth: CGFloat = 52
        
        let titleWidth = containerWidth - 16 - imageWidth - 16 - 16
        let nameHeight = action.name.height(for: titleWidth, font: .appFont(style: .medium, size: 20))
        let categoryHeight = action.category.height(for: titleWidth, font: .appFont(style: .regular, size: 12))
        let titleHeight = max(imageHeight, nameHeight + categoryHeight)
        
        let descriptionWidth = containerWidth - 16 - 16
        let descriptionHeight = action.description.height(for: descriptionWidth, font: .appFont(style: .regular, size: 17))
        
        let markerHeight = action.marker.height(for: .greatestFiniteMagnitude, font: .appFont(style: .medium, size: 13)) + 4 + 4
        
        let containerHeight = 16 + titleHeight + 12 + descriptionHeight + 12 + markerHeight + 16
        let cellHeight = 16 + containerHeight + 8
        return CGSize(width: width, height: cellHeight)
    }
}
