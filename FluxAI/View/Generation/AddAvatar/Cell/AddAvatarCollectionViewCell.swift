//
//  AddAvatarCollectionViewCell.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 10.03.25.
//

import UIKit
import SnapKit
import Combine

final class AddAvatarCollectionViewCell: UICollectionViewCell, IReusableView {

    private var image = UIImageView()
    private let delete = UIButton(type: .system)
    public var deleteSubject = PassthroughSubject<Bool, Never>()
    var cancellables = Set<AnyCancellable>()

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        makeButtonActions()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
        makeButtonActions()
    }

    private func setupUI() {
        self.image.layer.masksToBounds = true
        self.image.layer.cornerRadius = 13
        self.image.contentMode = .scaleAspectFill

        self.delete.setImage(UIImage(named: "deleteAvatar"), for: .normal)

        self.addSubview(image)
        self.addSubview(delete)
    }

    private func setupConstraints() {
        image.snp.makeConstraints { view in
            view.top.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview()
        }

        delete.snp.makeConstraints { view in
            view.centerX.equalToSuperview()
            view.centerY.equalToSuperview()
            view.height.equalTo(32)
            view.width.equalTo(32)
        }
    }

    public func setup(imageFromGallery: UIImage) {
        self.image.image = imageFromGallery
    }
}

extension AddAvatarCollectionViewCell {
    private func makeButtonActions() {
        self.delete.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }

    @objc func deleteTapped() {
        self.deleteSubject.send(true)
    }
}
