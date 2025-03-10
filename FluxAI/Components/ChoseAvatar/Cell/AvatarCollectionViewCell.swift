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
    private let editButton = UIButton(type: .system)
    public var editSubject = PassthroughSubject<Bool, Never>()
    var cancellables = Set<AnyCancellable>()

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        makeButtonActions()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        makeButtonActions()
    }

    private func setupUI(isPlus: Bool = false) {

        self.backgroundColor = UIColor.clear

        self.avatar.layer.masksToBounds = true
        self.avatar.layer.cornerRadius = 38
        self.avatar.layer.borderColor = UIColor.clear.cgColor
        self.avatar.layer.borderWidth = 2
        self.avatar.contentMode = .scaleAspectFill

        self.editButton.setImage(UIImage(named: "editAvatar"), for: .normal)

        self.addSubview(avatar)
        self.addSubview(name)
        self.addSubview(editButton)
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

        editButton.snp.makeConstraints { view in
            view.centerX.equalTo(avatar.snp.centerX)
            view.centerY.equalTo(avatar.snp.centerY)
            view.width.equalTo(24)
            view.height.equalTo(24)
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

extension AvatarCollectionViewCell {
    private func makeButtonActions() {
        self.editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }

    @objc private func editButtonTapped() {
        self.editSubject.send(true)
    }
}
