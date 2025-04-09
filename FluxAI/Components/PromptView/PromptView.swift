//
//  PromptView.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 01.03.25.
//

import UIKit

class PromptView: UIView {

    public let text = CustomTextView(placeholder: "Enter prompt...")

    let bottomLine = UIView()

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {

        self.backgroundColor = UIColor.clear

        self.addSubview(text)
        setupConstraints()
    }

    private func setupConstraints() {

        text.snp.makeConstraints { view in
            view.top.equalToSuperview()
            view.leading.trailing.equalToSuperview()
            view.height.equalTo(144)
        }
    }

    func getPromptText() -> String? {
        if self.text.text == "" {
            return nil
        } else {
            return text.text
        }
    }
}
