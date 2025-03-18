//
//  AddAvatarViewController.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 09.03.25.
//

import UIKit
import FluxAIViewModel
import SnapKit
import StoreKit
import ApphudSDK

class AddAvatarViewController: BaseViewController {

    var viewModel: ViewModel?

    private let header = UILabel(text: "Photos",
                                 textColor: UIColor.white,
                                 font: UIFont(name: "SFProText-Semibold", size: 18))
    private let addImage = DashedButton(type: .system)
    var collectionView: UICollectionView!
    private let create = UIButton(type: .system)
    private var collectionViewData: [UIImage] = []
    private var collectionViewDataFromSend: [URL] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = .black

        self.header.textAlignment = .left

        self.create.backgroundColor = UIColor(hex: "#7500D2")
        self.create.layer.masksToBounds = true
        self.create.layer.cornerRadius = 8
        self.create.setTitle("Create", for: .normal)
        self.create.setTitleColor(.white, for: .normal)
        self.create.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 15)

        self.addImage.setImage(UIImage(named: "addPhoto"), for: .normal)
        self.addImage.tintColor = .white
        self.addImage.backgroundColor = .black
        self.addImage.layer.cornerRadius = 10
        self.addImage.clipsToBounds = true

        let numberOfColumns: CGFloat = 3
        let spacing: CGFloat = 12
        let totalSpacing = ((numberOfColumns - 1) * spacing)
        let availableWidth = self.view.frame.width - totalSpacing
        let itemWidth = availableWidth / numberOfColumns

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: 146)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear

        collectionView.register(AddAvatarCollectionViewCell.self)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true

        collectionView.delegate = self
        collectionView.dataSource = self

        self.view.addSubview(header)
        self.view.addSubview(addImage)
        self.view.addSubview(collectionView)
        self.view.addSubview(create)
        setupConstraints()
        setupNavigationItems()
    }

    override func setupViewModel() {
        super.setupViewModel()

        guard let userID = self.viewModel?.userID else {
            return
        }

        let bundle = Bundle.main.bundleIdentifier ?? ""
        self.viewModel?.login(userId: userID,
                              gender: "m",
                              source: bundle)
    }

    func setupConstraints() {
        header.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(116)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(20)
        }

        addImage.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(12)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(72)
        }

        collectionView.snp.makeConstraints { view in
            view.top.equalTo(addImage.snp.bottom).offset(16)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.bottom.equalToSuperview()
        }

        create.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(42)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(40)
        }
    }

}

//MARK: Make buttons actions
extension AddAvatarViewController {
    
    private func makeButtonsAction() {
        self.addImage.addTarget(self, action: #selector(addImageTapped), for: .touchUpInside)
        self.create.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
    }

    func showBadAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @objc func createTapped() {
        guard let navigationController = self.navigationController else { return }
        guard let response = self.viewModel?.loginResponse else { return }

        if collectionViewDataFromSend.isEmpty {
            self.showBadAlert(message: "You don't have any added images. Add one or more images to continue the action.")
            return
        } else {

            AddAvatarRouter.showGenerateViewController(in: navigationController,
                                                       navigationModel: .init(photosFiles: self.collectionViewDataFromSend,
                                                                              previewFile: self.collectionViewDataFromSend.first!))
        }
    }

    @objc func addImageTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true)
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
            AddAvatarRouter.showUpdatePaymentViewController(in: navigationController)
        } else {
            AddAvatarRouter.showPaymentViewController(in: navigationController)
        }
    }
}

extension AddAvatarViewController: IViewModelableController {
    typealias ViewModel = IAddAvatarViewModel
}

//MARK: Collection view delegate
extension AddAvatarViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionViewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AddAvatarCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)

        let image = self.collectionViewData[indexPath.row]
        cell.setup(imageFromGallery: image)

        cell.deleteSubject.sink { [weak self] _ in
            self?.collectionViewData.remove(at: indexPath.row)
            self?.collectionView.reloadData()
        }.store(in: &cell.cancellables)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 3
        let spacing: CGFloat = 12
        let totalSpacing = ((numberOfColumns - 1) * spacing)
        let availableWidth = self.view.frame.width - totalSpacing - 32
        let itemWidth = availableWidth / numberOfColumns
        
        return CGSize(width: itemWidth, height: 146)
    }
}

//MARK: Image Picker
extension AddAvatarViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        guard let imageURL = info[.imageURL] as? URL else { return }

        self.collectionViewData.append(image)
        self.collectionViewDataFromSend.append(imageURL)
        self.collectionView.reloadData()
    }
}

//MARK: Preview
import SwiftUI

struct AddAvatarViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let addAvatarViewController = AddAvatarViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<AddAvatarViewControllerProvider.ContainerView>) -> AddAvatarViewController {
            return addAvatarViewController
        }

        func updateUIViewController(_ uiViewController: AddAvatarViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<AddAvatarViewControllerProvider.ContainerView>) {
        }
    }
}
