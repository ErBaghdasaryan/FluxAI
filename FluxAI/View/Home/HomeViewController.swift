//
//  HomeViewController.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 27.02.25.
//

import UIKit
import FluxAIViewModel
import SnapKit
import SDWebImage

class HomeViewController: BaseViewController {

    var viewModel: ViewModel?

    private let promptView = PromptView()
    private let useByPrompt = UIButton(type: .system)
    private let chooseAvatar = ChoseAvatarView()
    private let activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = .black

        self.useByPrompt.backgroundColor = UIColor(hex: "#7500D2")
        self.useByPrompt.layer.masksToBounds = true
        self.useByPrompt.layer.cornerRadius = 20
        self.useByPrompt.setTitle("Use by Prompt", for: .normal)
        self.useByPrompt.setTitleColor(.white, for: .normal)
        self.useByPrompt.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 15)

        self.activityIndicator.color = UIColor(hex: "#7500D2")
        self.activityIndicator.style = .large
        self.activityIndicator.hidesWhenStopped = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(choseTapped))
        tapGesture.cancelsTouchesInView = false
        self.chooseAvatar.addGestureRecognizer(tapGesture)

        self.view.addSubview(promptView)
        self.view.addSubview(useByPrompt)
        self.view.addSubview(chooseAvatar)
        self.view.addSubview(activityIndicator)
        setupConstraints()
        setupNavigationItems()
        setupViewTapHandling()
    }

    override func setupViewModel() {
        super.setupViewModel()

        let userId = "ios-test-user-12"

        self.viewModel?.getAvatars(userId: userId)

        self.viewModel?.createByPromptSuccessSubject.sink { success in
            if success {
//                let userId = "ios-test-user-11"
                guard let jobID = self.viewModel?.requestResponse?.data.jobID else { return }

                DispatchQueue.main.async {
                    self.activityIndicator.startAnimating()
                    self.view.isUserInteractionEnabled = false
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.viewModel?.fetchGenerationStatus(userId: userId, jobId: jobID)
                }
            } else {
                DispatchQueue.main.async {
                    self.showBadAlert(message: "Write the text that you want to generate, without which it is impossible to continue.")
                }
            }
        }.store(in: &cancellables)

        self.viewModel?.fetchGenerationSuccessSubject.sink { success in
            if success {
                guard let model = self.viewModel?.fetchGenerationModel?.data else { return }
                guard let prompt = self.promptView.getPromptText() else { return }

                self.loadImage(from: model.resultURL) { image in
                    if let image = image {
                        self.viewModel?.addHistory(.init(image: image,
                                                         date: model.finishedAt,
                                                         prompt: prompt))
                    }
                }

                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    self.showSuccessAlert(message: "You have successfully created your drawing! You can see it in the 'History' section.")
                }

            } else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    self.showBadAlert(message: "You couldn't create an image! Please try again.")
                }
            }
        }.store(in: &cancellables)

        self.viewModel?.avatarsLoadSuccessSubject.sink { success in
            if success {
                guard let model = self.viewModel?.avatars?.data else { return }

                self.chooseAvatar.setupAvatars(model: model)

            }
        }.store(in: &cancellables)
    }

    func setupConstraints() {

        promptView.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(108)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(296)
        }

        useByPrompt.snp.makeConstraints { view in
            view.top.equalTo(promptView.snp.bottom).offset(16)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(40)
        }

        chooseAvatar.snp.makeConstraints { view in
            view.top.equalTo(useByPrompt.snp.bottom).offset(28)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
        }

        activityIndicator.snp.makeConstraints { view in
            view.centerY.equalTo(promptView.snp.centerY)
            view.centerX.equalTo(promptView.snp.centerX)
            view.width.equalTo(30)
            view.height.equalTo(30)
        }
    }

}

//MARK: Make buttons actions
extension HomeViewController {
    
    private func makeButtonsAction() {
        useByPrompt.addTarget(self, action: #selector(useByPromptTapped), for: .touchUpInside)

        setupSubscriptions()
    }

    private func setupSubscriptions() {
        chooseAvatar.createTappedSubject.sink { [weak self] in
            self?.createByModelAvatar()
        }.store(in: &cancellables)

        chooseAvatar.plusTappedSubject.sink { [weak self] in
            self?.handleCreateAvatar()
        }.store(in: &cancellables)

        chooseAvatar.editTappedSubject.sink { [weak self] image in
            self?.showEditPhotoViewController(image: image)
        }.store(in: &cancellables)
    }

    private func showEditPhotoViewController(image: UIImage) {
        guard let navigationController = self.navigationController else { return }

        HomeRouter.showEditPhotoViewController(in: navigationController,
                                               navigationModel: .init(image: image))
    }

    private func handleCreateAvatar() {
        guard let navigationController = self.navigationController else { return }

        HomeRouter.showIntroViewController(in: navigationController)
    }

    private func createByModelAvatar() {
        guard let navigationController = self.navigationController else { return }
        guard let prompt = self.promptView.getPromptText() else {
            self.showBadAlert(message: "Write the text that you want to generate, without which it is impossible to continue.")
            return
        }
        guard let aspectRatio = self.promptView.getCurrentAspectRatio() else { return }
    }

    @objc func useByPromptTapped() {
        let userId = "ios-test-user-12"
        guard let prompt = self.promptView.getPromptText() else {
            self.showBadAlert(message: "Write the text that you want to generate, without which it is impossible to continue.")
            return
        }

        viewModel?.createByPromptRequest(userId: userId, prompt: prompt)
    }

    @objc private func choseTapped() {
        self.chooseAvatar.openButton()
        self.useByPrompt.backgroundColor = UIColor(hex: "#7500D2")?.withAlphaComponent(0.5)
        self.useByPrompt.isUserInteractionEnabled = false
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

        HomeRouter.showPaymentViewController(in: navigationController)
    }

    private func fetchImageUsingSDWebImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        SDWebImageManager.shared.loadImage(
            with: url,
            options: .highPriority,
            progress: nil
        ) { image, data, error, cacheType, finished, imageURL in
            if let error = error {
                print("Failed to fetch image: \(error.localizedDescription)")
                completion(nil)
                return
            }

            completion(image)
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

    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = URL(string: url) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }

            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}

extension HomeViewController: IViewModelableController {
    typealias ViewModel = IHomeViewModel
}

//MARK: UIGesture & cell's touches
extension HomeViewController: UITextFieldDelegate, UITextViewDelegate {

    @objc private func hideKeyboard() {
        self.view.endEditing(true)
        self.chooseAvatar.closeButton()
        self.useByPrompt.isUserInteractionEnabled = true
        self.useByPrompt.backgroundColor = UIColor(hex: "#7500D2")
    }

    private func setupViewTapHandling() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
}

//MARK: Preview
import SwiftUI

struct HomeViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let homeViewController = HomeViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<HomeViewControllerProvider.ContainerView>) -> HomeViewController {
            return homeViewController
        }

        func updateUIViewController(_ uiViewController: HomeViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<HomeViewControllerProvider.ContainerView>) {
        }
    }
}
