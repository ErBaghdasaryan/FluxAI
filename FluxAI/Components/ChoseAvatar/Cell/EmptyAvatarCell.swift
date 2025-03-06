//
//  EmptyAvatarCell.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 06.03.25.
//

import UIKit
import SnapKit

final class EmptyAvatarCell: UICollectionViewCell, IReusableView {

    private var image = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 28

        self.addSubview(image)
    }

    private func setupConstraints() {
        image.snp.makeConstraints { view in
            view.centerX.equalToSuperview()
            view.centerY.equalToSuperview()
            view.height.equalTo(56)
            view.width.equalTo(56)
        }
    }

    public func setup(image: String) {
        self.image.image = UIImage(named: image)
    }
}
