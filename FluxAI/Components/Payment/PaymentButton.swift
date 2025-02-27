//
//  PaymentButton.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 27.02.25.
//

import UIKit
import FluxAIModele

final class PaymentButton: UIButton {
    private let title = UILabel(text: "",
                                textColor: .white,
                                font: UIFont(name: "SFProText-Bold", size: 24))
    private let tokensCount = UILabel(text: "",
                                      textColor: UIColor(hex: "#5F6E85")!,
                                      font: UIFont(name: "SFProText-Regular", size: 12))
    private let saveLabel = UILabel(text: "Save 50%",
                                    textColor: .white,
                                    font: UIFont(name: "SFProText-Regular", size: 12))
    private let perWeek = UILabel(text: "",
                                  textColor: .white,
                                  font: UIFont(name: "SFProText-Regular", size: 16))
    var isSelectedState: Bool {
        willSet {
            if newValue {
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor(hex: "#7500D2")?.cgColor
                self.backgroundColor = UIColor(hex: "#0F0F0F")
            } else {
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.white.cgColor
                self.backgroundColor = .clear
            }
        }
    }
    private var isAnnual: PlanPresentationModel

    public init(isAnnual: PlanPresentationModel, isSelectedState: Bool = false) {
        self.isAnnual = isAnnual
        self.isSelectedState = isSelectedState
        super.init(frame: .zero)
        setupUI(isAnnual: isAnnual)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(isAnnual: PlanPresentationModel) {

        self.backgroundColor = .clear

        self.layer.cornerRadius = 12

        self.title.textAlignment = .left
        self.perWeek.textAlignment = .right

        self.saveLabel.layer.masksToBounds = true
        self.saveLabel.layer.cornerRadius = 8
        self.saveLabel.backgroundColor = UIColor(hex: "#FF4E4E")

        switch self.isAnnual {
        case .yearly:
            self.title.text = "Year"
            self.tokensCount.text = "(1200 Tokens)"
            self.perWeek.text = "6 300 ₽ "
            self.addSubview(saveLabel)
        case .weekly:
            self.title.text = "Week"
            self.tokensCount.text = "(100 Tokens)"
            self.perWeek.text = "1 150 ₽ "
            break
        }

        self.isSelectedState = false

        addSubview(title)
        addSubview(perWeek)
        addSubview(tokensCount)
        setupConstraints()
    }

    private func setupConstraints() {
        
        title.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(12)
            view.leading.equalToSuperview().offset(12)
            view.height.equalTo(26)
        }
        
        perWeek.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(12)
            view.height.equalTo(18)
        }

        tokensCount.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(20)
            view.leading.equalTo(title.snp.trailing).offset(15)
            view.height.equalTo(14)
        }

        switch self.isAnnual {
        case .yearly:
            saveLabel.snp.makeConstraints { view in
                view.top.equalToSuperview().offset(-10)
                view.trailing.equalToSuperview().inset(11.5)
                view.height.equalTo(22)
                view.width.equalTo(70)
            }
        default:
            break
        }
    }

    public func setup(with isYearly: String) {
        self.title.text = isYearly
    }
}

enum PlanPresentationModel {
    case yearly
    case weekly
}
