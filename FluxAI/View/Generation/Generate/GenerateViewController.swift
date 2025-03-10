//
//  GenerateViewController.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 09.03.25.
//

import UIKit
import FluxAIViewModel
import SnapKit
import StoreKit

class GenerateViewController: BaseViewController {

    var viewModel: ViewModel?

    private let header = UILabel(text: "Model generation...",
                                 textColor: UIColor.white,
                                 font: UIFont(name: "SFProText-Semibold", size: 24))
    private let subHeader = UILabel(text: "Generation usually takes about a 5 minutes",
                                    textColor: UIColor(hex: "#8D929B")!,
                                    font: UIFont(name: "SFProText-Regular", size: 16))
    private let loadingImage = UIImageView(image: UIImage(named: "loadingImage"))
    private let progressView = UIProgressView(progressViewStyle: .default)
    private var progressTimer: Timer?
    private var elapsedTime: TimeInterval = 0
    private let totalGenerationTime: TimeInterval = 360

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startProgressTimer()
        self.sendRequests()
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = .black

        progressView.progress = 0.0
        progressView.trackTintColor = .white
        progressView.tintColor = UIColor(hex: "#7500D2")

        self.view.addSubview(header)
        self.view.addSubview(subHeader)
        self.view.addSubview(loadingImage)
        self.view.addSubview(progressView)
        setupConstraints()
        setupNavigationItems()
    }

    override func setupViewModel() {
        super.setupViewModel()

        self.viewModel?.createAvatarSuccessSubject.sink { success in
            if success {
                DispatchQueue.main.async {
                    self.startGenerationProcess()
                }
            } else {
                DispatchQueue.main.async {
                    self.showBadAlert(message: "You already have a request to create one avatar, there can't be two requests at the same time..")
                }
            }
        }.store(in: &cancellables)
    }

    func setupConstraints() {
        header.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(230)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(26)
        }

        subHeader.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(8)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(18)
        }

        loadingImage.snp.makeConstraints { view in
            view.top.equalTo(subHeader.snp.bottom).offset(8)
            view.leading.equalToSuperview().offset(43)
            view.trailing.equalToSuperview().inset(43)
            view.height.equalTo(267)
        }

        progressView.snp.makeConstraints { view in
            view.top.equalTo(loadingImage.snp.bottom).offset(24)
            view.leading.equalToSuperview().offset(60)
            view.trailing.equalToSuperview().inset(60)
        }
    }

}

//MARK: Make buttons actions
extension GenerateViewController {
    
    private func makeButtonsAction() {
    }

    private func sendRequests() {
        let userId = "ios-test-user-12"
        let gender = "m"
        guard let photos = self.viewModel?.photosFiles else { return }
        guard let preview = self.viewModel?.previewFile else { return }

        self.viewModel?.createAvatarRequest(userId: userId,
                                            gender: gender,
                                            photos: photos,
                                            preview: preview)
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

    private func setupNavigationItems() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "proButton"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button.addTarget(self, action: #selector(getProSubscription), for: .touchUpInside)

        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "cancel"), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        let proButton = UIBarButtonItem(customView: button)
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItem = proButton
        navigationItem.leftBarButtonItem = backButtonItem
    }

    @objc func backButtonTapped() {
        guard let navigationController = self.navigationController else { return }

        GenerateRouter.popViewController(in: navigationController)
    }

    @objc func getProSubscription() {
        guard let navigationController = self.navigationController else { return }

        GenerateRouter.showPaymentViewController(in: navigationController)
    }

    private func startGenerationProcess() {
        self.startProgressTimer()

        DispatchQueue.main.asyncAfter(deadline: .now() + totalGenerationTime) {
            self.onGenerationCompleted()
        }
    }

    private func startProgressTimer() {
        progressView.progress = 0.0
        elapsedTime = 0

        progressTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }

            self.elapsedTime += 1
            let progress = Float(self.elapsedTime / self.totalGenerationTime)
            self.progressView.setProgress(progress, animated: true)

            if self.elapsedTime >= self.totalGenerationTime {
                timer.invalidate()
            }
        }
    }

    private func onGenerationCompleted() {
        DispatchQueue.main.async {
            self.showSuccessAlert(message: "Your avatar has been successfully created, you can see the avatar")

            guard let navigationController = self.navigationController else { return }
            GenerateRouter.showTabBarViewController(in: navigationController)
        }
    }
}

extension GenerateViewController: IViewModelableController {
    typealias ViewModel = IGenerateViewModel
}

//MARK: Preview
import SwiftUI

struct GenerateViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let generateViewController = GenerateViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<GenerateViewControllerProvider.ContainerView>) -> GenerateViewController {
            return generateViewController
        }

        func updateUIViewController(_ uiViewController: GenerateViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<GenerateViewControllerProvider.ContainerView>) {
        }
    }
}
