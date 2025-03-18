//
//  UpdatePaymentButton.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 18.03.25.
//

import UIKit
import FluxAIModele

final class UpdatePaymentButton: UIButton {
    private let title = UILabel(text: "",
                                textColor: .white,
                                font: UIFont(name: "SFProText-Bold", size: 16))
    private let tokensCount = UILabel(text: "",
                                      textColor: UIColor.white,
                                      font: UIFont(name: "SFProText-Regular", size: 16))
    private let saveLabel = UILabel(text: "Save 50%",
                                    textColor: .white,
                                    font: UIFont(name: "SFProText-Regular", size: 12))
    private let perWeek = UILabel(text: "",
                                  textColor: .white,
                                  font: UIFont(name: "SFProText-Semibold", size: 18))
    var isSelectedState: Bool {
        didSet {
            self.updateBorder()
        }
    }
    private let borderLayer = CAShapeLayer()

    public init(header: String, subheader: String, isSelectedState: Bool = false) {
        self.isSelectedState = isSelectedState
        self.title.text = header
        self.tokensCount.text = subheader
        super.init(frame: .zero)
        setupUI()
        self.setupBorder()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateBorder()
    }

    private func setupUI() {

        self.backgroundColor = .clear

        self.layer.cornerRadius = 12

        self.title.textAlignment = .left
        self.perWeek.textAlignment = .right

        self.saveLabel.layer.masksToBounds = true
        self.saveLabel.layer.cornerRadius = 12
        self.saveLabel.backgroundColor = UIColor(hex: "#FF4E4E")

        self.saveLabel.layer.zPosition = 1

        self.isSelectedState = false

        addSubview(title)
        addSubview(perWeek)
        addSubview(tokensCount)
        addSubview(saveLabel)
        setupConstraints()
    }

    private func setupConstraints() {

        title.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(12)
            view.leading.equalToSuperview().offset(12)
            view.height.equalTo(18)
        }

        perWeek.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(24)
            view.trailing.equalToSuperview().inset(12)
            view.height.equalTo(18)
        }

        tokensCount.snp.makeConstraints { view in
            view.top.equalTo(title.snp.bottom).offset(7)
            view.leading.equalToSuperview().offset(12)
            view.height.equalTo(18)
        }

        saveLabel.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(-10)
            view.trailing.equalToSuperview().inset(11.5)
            view.height.equalTo(22)
            view.width.equalTo(70)
        }
    }

    public func setup(with isYearly: String) {
        self.title.text = isYearly
    }

    private func setupBorder() {
        borderLayer.lineWidth = 1
        borderLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(borderLayer)
        updateBorder()
    }

    private func updateBorder() {
        borderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
        borderLayer.strokeColor = (isSelectedState ? UIColor(hex: "#7500D2")?.cgColor : UIColor.white.cgColor)
    }

    func toggleSelection() {
        isSelectedState.toggle()
    }
}
