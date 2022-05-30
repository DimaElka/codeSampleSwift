//
//  ActionInfoItemView.swift
//  Mir
//
//  Created by Dmitry Rogov on 07.12.2021.
//

import UIKit
import RxCocoa

class ActionInfoItemView: BaseView {
    //MARK: Properties
    private var imageView: UIImageView!
    private var titleLabel: UILabel!
    private var selectButton: UIButton!
    
    var selectTrigger: ControlEvent<Void> { selectButton.rx.tap }
    
    //MARK: - LifeCycle
    override func initialSetup() {
        makeUI()
    }
    
    //MARK: - Functions
    func configure(title: String, image: UIImage) {
        titleLabel.text = title
        imageView.image = image
    }
}

//MARK: - UI
extension ActionInfoItemView {
    private func makeUI() {
        imageView = UIImageView()
        imageView.contentMode = .center
        imageView.backgroundColor = .color(named: .main)
        imageView.roundCorners(with: 20)
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().inset(4)
            $0.height.width.equalTo(40)
        }
        
        titleLabel = UILabel()
        titleLabel.font = .appFont(style: .medium, size: 15)
        titleLabel.textColor = .color(named: .text)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(imageView.snp.right).offset(16)
            $0.right.equalToSuperview().inset(16)
        }
        
        selectButton = UIButton()
        selectButton.setTitle(nil, for: .normal)
        addSubview(selectButton)
        selectButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
