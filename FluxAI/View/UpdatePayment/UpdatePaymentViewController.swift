//
//  UpdatePaymentViewController.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 18.03.25.
//

import UIKit
import FluxAIViewModel
import SnapKit
import ApphudSDK

class UpdatePaymentViewController: BaseViewController {

    var viewModel: ViewModel?

    private let background = UIImageView(image: UIImage(named: "updatePaymentBG"))
    private let bottomView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemThickMaterialDark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0.6
        view.isUserInteractionEnabled = false
        return view
    }()
    private let afterBottom = UIView()
    private let header = UILabel(text: "Full Glam AI power",
                                 textColor: .white,
                                 font: UIFont(name: "SFProText-Bold", size: 32))

    private let grabTheDeal = UIButton(type: .system)
    private let terms = UIButton(type: .system)
    private let privacy = UIButton(type: .system)
    private let restore = UIButton(type: .system)
    private var buttonsStack: UIStackView!
    private let cancele = UIButton(type: .system)

    private let tokensFirst = UpdatePaymentButton(header: "5000 Tokens", subheader: "250.00 $")
    private let tokensSecond = UpdatePaymentButton(header: "1000 Tokens", subheader: "66.00 $")
    private let tokensThird = UpdatePaymentButton(header: "300 Tokens", subheader: "23.00 $")
    private let tokensFourth = UpdatePaymentButton(header: "100 Tokens", subheader: "9.00 $")
    private let avatarSecond = UpdatePaymentButton(header: "Avatar", subheader: "5.89 $")

    private var currentProduct: ApphudProduct?
    public let paywallID = "consumable"
    public var productsAppHud: [ApphudProduct] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
        self.loadPaywalls()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.cancele.isHidden = false
        }
        self.navigationController?.navigationBar.isHidden = true
    }

    override func setupUI() {
        super.setupUI()

        self.grabTheDeal.setTitle("Grab the deal", for: .normal)
        self.grabTheDeal.setTitleColor(.white, for: .normal)
        self.grabTheDeal.layer.cornerRadius = 8
        self.grabTheDeal.layer.masksToBounds = true
        self.grabTheDeal.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 15)
        self.grabTheDeal.backgroundColor = UIColor(hex: "#7500D2")

        self.bottomView.layer.masksToBounds = true
        self.bottomView.layer.cornerRadius = 16
        self.afterBottom.layer.masksToBounds = true
        self.afterBottom.layer.cornerRadius = 16
        self.afterBottom.backgroundColor = .black.withAlphaComponent(0.4)

        self.background.frame = self.view.bounds

        self.privacy.setTitle("Privacy policy", for: .normal)
        self.privacy.setTitleColor(UIColor(hex: "#8D929B"), for: .normal)
        self.privacy.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 12)

        self.terms.setTitle("Terms of Use", for: .normal)
        self.terms.setTitleColor(UIColor(hex: "#8D929B"), for: .normal)
        self.terms.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 12)

        self.restore.setTitle("Restore purchases", for: .normal)
        self.restore.setTitleColor(UIColor(hex: "#8D929B"), for: .normal)
        self.restore.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 12)

        self.buttonsStack = UIStackView(arrangedSubviews: [terms,
                                                           privacy,
                                                           restore],
                                        axis: .horizontal,
                                        spacing: 0)
        self.buttonsStack.distribution = .fillEqually

        let image = UIImage(named: "maybeLater")
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: -6, width: 20, height: 20)

        let attachmentString = NSAttributedString(attachment: attachment)
        let text = NSMutableAttributedString(string: " Cancel anytime")
        text.insert(attachmentString, at: 0)

        self.cancele.setImage(UIImage(named: "cancel"), for: .normal)

        self.cancele.isHidden = true

        self.view.addSubview(background)
        self.view.addSubview(bottomView)
        self.view.addSubview(afterBottom)
        self.view.addSubview(cancele)
        self.view.addSubview(header)
        self.view.addSubview(tokensFirst)
        self.view.addSubview(tokensSecond)
        self.view.addSubview(tokensThird)
        self.view.addSubview(tokensFourth)
        self.view.addSubview(avatarSecond)
        self.view.addSubview(grabTheDeal)
        self.view.addSubview(buttonsStack)
        setupConstraints()
    }

    override func setupViewModel() {
        super.setupViewModel()
    }

    func setupConstraints() {

        bottomView.snp.makeConstraints { view in
            view.bottom.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalTo(647)
        }

        afterBottom.snp.makeConstraints { view in
            view.bottom.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalTo(647)
        }

        cancele.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(56)
            view.leading.equalToSuperview().offset(16)
            view.width.equalTo(32)
            view.height.equalTo(32)
        }

        header.snp.makeConstraints { view in
            view.top.equalTo(bottomView.snp.top).offset(16)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(34)
        }

        tokensFirst.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(34)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(67)
        }

        tokensSecond.snp.makeConstraints { view in
            view.top.equalTo(tokensFirst.snp.bottom).offset(22)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(67)
        }

        tokensThird.snp.makeConstraints { view in
            view.top.equalTo(tokensSecond.snp.bottom).offset(22)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(67)
        }

        tokensFourth.snp.makeConstraints { view in
            view.top.equalTo(tokensThird.snp.bottom).offset(22)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(67)
        }

        avatarSecond.snp.makeConstraints { view in
            view.top.equalTo(tokensFourth.snp.bottom).offset(22)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(67)
        }

        grabTheDeal.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(68)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(40)
        }

        buttonsStack.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(42)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(14)
        }
    }

}

//MARK: Make buttons actions
extension UpdatePaymentViewController {
    
    private func makeButtonsAction() {
        grabTheDeal.addTarget(self, action: #selector(grabTheDealTaped), for: .touchUpInside)
        restore.addTarget(self, action: #selector(restoreTapped), for: .touchUpInside)
        privacy.addTarget(self, action: #selector(privacyTapped), for: .touchUpInside)
        terms.addTarget(self, action: #selector(termsTapped), for: .touchUpInside)
        cancele.addTarget(self, action: #selector(cancelTaped), for: .touchUpInside)
        tokensFirst.addTarget(self, action: #selector(planAction(_:)), for: .touchUpInside)
        tokensSecond.addTarget(self, action: #selector(planAction(_:)), for: .touchUpInside)
        tokensThird.addTarget(self, action: #selector(planAction(_:)), for: .touchUpInside)
        tokensFourth.addTarget(self, action: #selector(planAction(_:)), for: .touchUpInside)
        avatarSecond.addTarget(self, action: #selector(planAction(_:)), for: .touchUpInside)
    }

    @objc func planAction(_ sender: UIButton) {
        switch sender {
        case tokensFirst:
            self.tokensFirst.isSelectedState = true
            self.tokensSecond.isSelectedState = false
            self.tokensThird.isSelectedState = false
            self.tokensFourth.isSelectedState = false
            self.avatarSecond.isSelectedState = false
            self.currentProduct = self.productsAppHud[1]
        case tokensSecond:
            self.tokensFirst.isSelectedState = false
            self.tokensSecond.isSelectedState = true
            self.tokensThird.isSelectedState = false
            self.tokensFourth.isSelectedState = false
            self.avatarSecond.isSelectedState = false
            self.currentProduct = self.productsAppHud[3]
        case tokensThird:
            self.tokensFirst.isSelectedState = false
            self.tokensSecond.isSelectedState = false
            self.tokensThird.isSelectedState = true
            self.tokensFourth.isSelectedState = false
            self.avatarSecond.isSelectedState = false
            self.currentProduct = self.productsAppHud[2]
        case tokensFourth:
            self.tokensFirst.isSelectedState = false
            self.tokensSecond.isSelectedState = false
            self.tokensThird.isSelectedState = false
            self.tokensFourth.isSelectedState = true
            self.avatarSecond.isSelectedState = false
            self.currentProduct = self.productsAppHud[4]
        case avatarSecond:
            self.tokensFirst.isSelectedState = false
            self.tokensSecond.isSelectedState = false
            self.tokensThird.isSelectedState = false
            self.tokensFourth.isSelectedState = false
            self.avatarSecond.isSelectedState = true
            self.currentProduct = self.productsAppHud.first
        default:
            break
        }
    }

    @objc func cancelTaped() {
        if let navigationController = self.navigationController {
            let viewControllers = navigationController.viewControllers

            if let currentIndex = viewControllers.firstIndex(of: self), currentIndex > 0 {
                let previousViewController = viewControllers[currentIndex - 1]

                if previousViewController is NotificationViewController {
                    UpdatePaymentRouter.showTabBarViewController(in: navigationController)
                } else if previousViewController is IntroViewController {
                    UpdatePaymentRouter.showTabBarFromIntroViewController(in: navigationController)
                } else {
                    navigationController.navigationBar.isHidden = false
                    navigationController.navigationItem.hidesBackButton = false
                    navigationController.popViewController(animated: true)
                }
            }
        }
    }

    @objc func privacyTapped() {
        guard let navigationController = self.navigationController else { return }
        PyamentRouter.showPrivacyViewController(in: navigationController)
    }

    @objc func termsTapped() {
        guard let navigationController = self.navigationController else { return }
        PyamentRouter.showTermsViewController(in: navigationController)
    }

    @objc func grabTheDealTaped() {
        if let navigationController = self.navigationController {
            guard let currentProduct = self.currentProduct else { return }

            let viewControllers = navigationController.viewControllers
            startPurchase(product: currentProduct) { result in

                if let currentIndex = viewControllers.firstIndex(of: self), currentIndex > 0 {
                    let previousViewController = viewControllers[currentIndex - 1]

                    if previousViewController is NotificationViewController {
                        UpdatePaymentRouter.showTabBarViewController(in: navigationController)
                    } else {
                        DispatchQueue.main.async {
                            navigationController.navigationBar.isHidden = false
                            navigationController.navigationItem.hidesBackButton = false
                            navigationController.popViewController(animated: true)
                        }
                    }
                }
            }
        }
    }

    @objc func restoreTapped() {
        guard let navigationController = self.navigationController else { return }
        self.restorePurchase { result in
            if result {
                self.showSuccessAlert(message: "You have successfully restored your purchases.")
            } else {
                self.showBadAlert(message: "Your purchase could not be restored. Please try again later.")
            }
        }

        let viewControllers = navigationController.viewControllers

        if let currentIndex = viewControllers.firstIndex(of: self), currentIndex > 0 {
            let previousViewController = viewControllers[currentIndex - 1]

            if previousViewController is NotificationViewController {
                UpdatePaymentRouter.showTabBarViewController(in: navigationController)
            } else {
                navigationController.navigationBar.isHidden = false
                navigationController.navigationItem.hidesBackButton = false
                navigationController.popViewController(animated: true)
            }
        }
    }

    @MainActor
    public func startPurchase(product: ApphudProduct, escaping: @escaping(Bool) -> Void) {
        let selectedProduct = product
        Apphud.purchase(selectedProduct) { result in
            if let error = result.error {
                print(error.localizedDescription)
                escaping(false)
            }

            if let subscription = result.subscription, subscription.isActive() {
                escaping(true)
            } else if let purchase = result.nonRenewingPurchase, purchase.isActive() {
                escaping(true)
            } else {
                if Apphud.hasActiveSubscription() {
                    escaping(true)
                }
            }
        }
    }

    @MainActor
    public func restorePurchase(escaping: @escaping(Bool) -> Void) {
        Apphud.restorePurchases { subscriptions, _, error in
            if let error = error {
                print(error.localizedDescription)
                escaping(false)
            }
            if subscriptions?.first?.isActive() ?? false {
                escaping(true)
            }
            if Apphud.hasActiveSubscription() {
                escaping(true)
            }
        }
    }

    @MainActor
    public func loadPaywalls() {
        Apphud.paywallsDidLoadCallback { paywalls, error in
            if let error = error {
                print("Ошибка загрузки paywalls: \(error.localizedDescription)")
            } else if let paywall = paywalls.first(where: { $0.identifier == self.paywallID }) {
                Apphud.paywallShown(paywall)
                self.productsAppHud = paywall.products
                print("Продукты успешно загружены: \(self.productsAppHud)")
            } else {
                print("Paywall с идентификатором \(self.paywallID) не найден.")
            }
        }
    }

    func showSuccessAlert(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func showBadAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension UpdatePaymentViewController: IViewModelableController {
    typealias ViewModel = IPaymentViewModel
}


//MARK: Preview
import SwiftUI

struct UpdatePaymentViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let updatePaymentViewController = UpdatePaymentViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<UpdatePaymentViewControllerProvider.ContainerView>) -> UpdatePaymentViewController {
            return updatePaymentViewController
        }

        func updateUIViewController(_ uiViewController: UpdatePaymentViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<UpdatePaymentViewControllerProvider.ContainerView>) {
        }
    }
}
