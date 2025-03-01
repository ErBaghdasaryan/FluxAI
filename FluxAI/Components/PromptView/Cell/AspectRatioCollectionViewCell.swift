//
//  AspectRatioCollectionViewCell.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 01.03.25.
//

import UIKit
import Combine
import FluxAIModele

class AspectRatioCollectionViewCell: UICollectionViewCell, IReusableView {

    private let date = UILabel(text: "",
                               textColor: UIColor.white,
                               font: UIFont(name: "SFProText-Regular", size: 12))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {

        self.backgroundColor = UIColor.clear

        self.date.layer.masksToBounds = true
        self.date.layer.cornerRadius = 15
        self.date.layer.borderColor = UIColor(hex: "#A09E9E")?.cgColor
        self.date.layer.borderWidth = 1

        self.addSubview(date)
        setupConstraints()
    }

    private func setupConstraints() {
        date.snp.makeConstraints { view in
            view.top.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview()
        }
    }

    func setup(with text: String) {
        self.date.text = text
    }

    func updateSelectionState(isSelected: Bool) {
        self.backgroundColor = isSelected ? UIColor(hex: "#920DFA") : UIColor.clear
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        self.layer.borderWidth = isSelected ? 0 : 1
        self.layer.borderColor = UIColor.white.cgColor
    }
}
