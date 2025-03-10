//
//  EditPhotoViewController.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 10.03.25.
//

import UIKit
import FluxAIViewModel
import SnapKit
import StoreKit
import Photos

class EditPhotoViewController: BaseViewController {

    var viewModel: ViewModel?

    private let presentedImage = UIImageView()
    private let saveButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let image = self.viewModel?.image else { return }

        self.presentedImage.image = image
    }

    override func setupUI() {
        super.setupUI()

        self.presentedImage.frame = self.view.bounds
        self.presentedImage.contentMode = .scaleAspectFill

        self.saveButton.setTitle("Save", for: .normal)
        self.saveButton.setTitleColor(.white, for: .normal)
        self.saveButton.layer.masksToBounds = true
        self.saveButton.layer.cornerRadius = 24
        self.saveButton.backgroundColor = .black.withAlphaComponent(0.4)
        let icon = UIImage(named: "saveImage")
        saveButton.setImage(icon, for: .normal)
        saveButton.semanticContentAttribute = .forceLeftToRight
        saveButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        saveButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 14)

        self.view.addSubview(presentedImage)
        self.view.addSubview(saveButton)
        setupConstraints()
        setupNavigationItems()
    }

    override func setupViewModel() {
        super.setupViewModel()
    }

    func setupConstraints() {
        saveButton.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(32)
            view.leading.equalToSuperview().offset(119)
            view.trailing.equalToSuperview().inset(119)
            view.height.equalTo(48)
        }
    }

}

//MARK: Make buttons actions
extension EditPhotoViewController {
    
    private func makeButtonsAction() {
        self.saveButton.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
    }

    @objc func saveImage() {
        guard let imageToSave = presentedImage.image else { return }

        PHPhotoLibrary.requestAuthorization { [self] status in
            if status == .authorized {
                UIImageWriteToSavedPhotosAlbum(imageToSave, self, #selector(self.imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
            } else {
                showBadAlert(message: "There is no permission to save the image.")
            }
        }
    }

    @objc func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showBadAlert(message: "Saving error.")
        } else {

            DispatchQueue.main.async {
                self.showSuccessAlert(message: "Image has been saved to your gallery.")
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

        EditPhotoRouter.popViewController(in: navigationController)
    }

    @objc func getProSubscription() {
        guard let navigationController = self.navigationController else { return }

        EditPhotoRouter.showPaymentViewController(in: navigationController)
    }
}

extension EditPhotoViewController: IViewModelableController {
    typealias ViewModel = IEditPhotoViewModel
}

//MARK: Preview
import SwiftUI

struct EditPhotoViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let editPhotoViewController = EditPhotoViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<EditPhotoViewControllerProvider.ContainerView>) -> EditPhotoViewController {
            return editPhotoViewController
        }

        func updateUIViewController(_ uiViewController: EditPhotoViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<EditPhotoViewControllerProvider.ContainerView>) {
        }
    }
}
