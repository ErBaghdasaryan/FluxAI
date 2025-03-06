//
//  AvatarCollectionViewCell.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 06.03.25.
//

import UIKit
import Combine
import FluxAIModele

class AvatarCollectionViewCell: UICollectionViewCell, IReusableView {

    private let avatar = UIImageView()
    private let name = UILabel(text: "",
                               textColor: UIColor(hex: "#8D929B")!,
                               font: UIFont(name: "SFProText-Regular", size: 12))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI(isPlus: Bool = false) {

        self.backgroundColor = UIColor.clear

        self.avatar.layer.masksToBounds = true
        self.avatar.layer.cornerRadius = 38
        self.avatar.layer.borderColor = UIColor.clear.cgColor
        self.avatar.layer.borderWidth = 2

        self.addSubview(avatar)
        self.addSubview(name)
        setupConstraints()
    }

    private func setupConstraints(isPlus: Bool = false) {
        if !isPlus {
            avatar.snp.makeConstraints { view in
                view.top.equalToSuperview()
                view.leading.equalToSuperview()
                view.trailing.equalToSuperview()
                view.bottom.equalToSuperview().inset(18)
            }
        } else {
            avatar.snp.makeConstraints { view in
                view.top.equalToSuperview().offset(19.5)
                view.leading.equalToSuperview()
                view.trailing.equalToSuperview()
                view.bottom.equalToSuperview().inset(19.5)
            }
        }

        name.snp.makeConstraints { view in
            view.top.equalTo(avatar.snp.bottom).offset(4)
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview()
        }
    }

    func setup(with name: String, image: UIImage, isPlus: Bool = false) {
        self.name.text = name
        self.avatar.image = image
        setupUI(isPlus: isPlus)
    }

    func updateSelectionState(isSelected: Bool) {
        self.avatar.layer.borderWidth = isSelected ? 4 : 0
        self.avatar.layer.borderColor = isSelected ? UIColor(hex: "#920DFA")?.cgColor : UIColor.white.cgColor
    }
}
