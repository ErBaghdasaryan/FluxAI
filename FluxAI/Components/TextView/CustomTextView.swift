//
//  CustomTextView.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 01.03.25.
//

import UIKit

public class CustomTextView: UITextView, UITextViewDelegate {

    private var placeholderText: String = ""
    public var placeholderLabel: UILabel = UILabel()

    public convenience init(placeholder: String) {
        self.init()
        self.placeholderText = placeholder

        configure()
    }

    private func configure() {

        self.layer.masksToBounds = true
        self.layer.cornerRadius = 16
        self.backgroundColor = UIColor.clear

        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hex: "#A09E9E")?.cgColor

        placeholderLabel.text = placeholderText
        placeholderLabel.font = UIFont(name: "SFProText-Regular", size: 16)
        placeholderLabel.textAlignment = .left
        placeholderLabel.numberOfLines = 2
        addSubview(placeholderLabel)

        placeholderLabel.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(12)
            view.leading.equalToSuperview().offset(12)
            view.trailing.equalToSuperview().inset(12)
            view.bottom.equalToSuperview()
        }

        placeholderLabel.isHidden = !text.isEmpty

        self.placeholderLabel.attributedText = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4)])

        self.textColor = .white
        self.textAlignment = .left
        self.font = UIFont(name: "SFProText-Regular", size: 16)

        self.delegate = self
    }

    // MARK: UITextViewDelegate
    public func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
