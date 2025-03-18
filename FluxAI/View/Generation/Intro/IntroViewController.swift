//
//  IntroViewController.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 09.03.25.
//

import UIKit
import FluxAIViewModel
import SnapKit
import StoreKit
import ApphudSDK

class IntroViewController: BaseViewController {

    var viewModel: ViewModel?

    private let header = UILabel(text: "Pick 5-10 photos of yourself",
                                 textColor: UIColor.white,
                                 font: UIFont(name: "SFProText-Semibold", size: 18))
    private let subHeader = UILabel(text: "The simplest photos are the best !",
                                    textColor: UIColor(hex: "#FFE500")!,
                                    font: UIFont(name: "SFProText-Regular", size: 16))
    private let goodPhotos = ImageLabelView(image: UIImage(named: "goodPhoto")!,
                                            text: "Good Photos")
    private let goodIntro = UILabel(text: "Chose 5-10 selfies of yourself from various angels, different backgrounds, lighting, different days.",
                                    textColor: UIColor(hex: "#8D929B")!,
                                    font: UIFont(name: "SFProText-Regular", size: 16))
    private let firstGood = UIImageView(image: UIImage(named: "good1"))
    private let secondGood = UIImageView(image: UIImage(named: "good2"))
    private let thirdGood = UIImageView(image: UIImage(named: "good3"))
    private var goodStack: UIStackView!
    private let badPhotos = ImageLabelView(image: UIImage(named: "badPhoto")!,
                                            text: "Bad Photos")
    private let badIntro = UILabel(text: "Please do not use multiple identical shots, pictures with a covered faces, or nudes.",
                                    textColor: UIColor(hex: "#8D929B")!,
                                    font: UIFont(name: "SFProText-Regular", size: 16))
    private let firstBad = UIImageView(image: UIImage(named: "bad1"))
    private let secondBad = UIImageView(image: UIImage(named: "bad2"))
    private let thirdBad = UIImageView(image: UIImage(named: "bad3"))
    private var badStack: UIStackView!
    private let upload = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = .black

        self.header.textAlignment = .left
        self.subHeader.textAlignment = .left

        self.goodIntro.textAlignment = .left
        self.goodIntro.numberOfLines = 0
        self.goodIntro.lineBreakMode = .byWordWrapping

        self.badIntro.textAlignment = .left
        self.badIntro.numberOfLines = 0
        self.badIntro.lineBreakMode = .byWordWrapping

        self.goodStack = UIStackView(arrangedSubviews: [firstGood, secondGood, thirdGood],
                                     axis: .horizontal,
                                     spacing: 20)
        self.goodStack.distribution = .fillEqually

        self.badStack = UIStackView(arrangedSubviews: [firstBad, secondBad, thirdBad],
                                     axis: .horizontal,
                                     spacing: 20)
        self.badStack.distribution = .fillEqually

        self.upload.backgroundColor = UIColor(hex: "#7500D2")
        self.upload.layer.masksToBounds = true
        self.upload.layer.cornerRadius = 8
        self.upload.setTitle("Upload Photo", for: .normal)
        self.upload.setTitleColor(.white, for: .normal)
        self.upload.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 15)

        self.view.addSubview(header)
        self.view.addSubview(subHeader)
        self.view.addSubview(goodPhotos)
        self.view.addSubview(goodIntro)
        self.view.addSubview(goodStack)
        self.view.addSubview(badPhotos)
        self.view.addSubview(badIntro)
        self.view.addSubview(badStack)
        self.view.addSubview(upload)
        setupConstraints()
        setupNavigationItems()
    }

    override func setupViewModel() {
        super.setupViewModel()
    }

    func setupConstraints() {
        header.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(116)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(20)
        }

        subHeader.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(4)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(18)
        }

        goodPhotos.snp.makeConstraints { view in
            view.top.equalTo(subHeader.snp.bottom).offset(20)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(24)
        }

        goodIntro.snp.makeConstraints { view in
            view.top.equalTo(goodPhotos.snp.bottom).offset(8)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
        }

        goodStack.snp.makeConstraints { view in
            view.top.equalTo(goodIntro.snp.bottom).offset(12)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(150)
        }

        badPhotos.snp.makeConstraints { view in
            view.top.equalTo(goodStack.snp.bottom).offset(16)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(24)
        }

        badIntro.snp.makeConstraints { view in
            view.top.equalTo(badPhotos.snp.bottom).offset(8)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
        }

        badStack.snp.makeConstraints { view in
            view.top.equalTo(badIntro.snp.bottom).offset(12)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(150)
        }

        upload.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(42)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(40)
        }
    }

}

//MARK: Make buttons actions
extension IntroViewController {
    
    private func makeButtonsAction() {
        self.upload.addTarget(self, action: #selector(uploadTapped), for: .touchUpInside)
    }

    @objc func uploadTapped() {
        guard let navigationController = self.navigationController else { return }

        IntroRouter.showAddAvatarViewController(in: navigationController)
    }

    private func setupNavigationItems() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "getPro"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 113, height: 32)
        button.addTarget(self, action: #selector(getProSubscription), for: .touchUpInside)

        let proButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = proButton
    }

    @objc func getProSubscription() {
        guard let navigationController = self.navigationController else { return }

        if Apphud.hasActiveSubscription() {
            IntroRouter.showUpdatePaymentViewController(in: navigationController)
        } else {
            IntroRouter.showPaymentViewController(in: navigationController)
        }
    }
}

extension IntroViewController: IViewModelableController {
    typealias ViewModel = IIntroViewModel
}

//MARK: Preview
import SwiftUI

struct IntroViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let introViewController = IntroViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<IntroViewControllerProvider.ContainerView>) -> IntroViewController {
            return introViewController
        }

        func updateUIViewController(_ uiViewController: IntroViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<IntroViewControllerProvider.ContainerView>) {
        }
    }
}
