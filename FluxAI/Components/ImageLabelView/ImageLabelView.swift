//
//  ImageLabelView.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 10.03.25.
//

import UIKit
import SnapKit

class ImageLabelView: UIView {

    private let imageView = UIImageView()
    private let label = UILabel()

    init(image: UIImage, text: String) {
        super.init(frame: .zero)
        setupView()

        imageView.image = image
        label.text = text
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        imageView.contentMode = .scaleAspectFit
        label.textColor = .white
        label.font = UIFont(name: "SFProText-Regular", size: 16)
        label.textAlignment = .left

        addSubview(imageView)
        addSubview(label)

        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }

        label.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}
